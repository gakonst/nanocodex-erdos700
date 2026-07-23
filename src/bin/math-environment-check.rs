use std::{env, process::ExitCode};

use eyre::{Result, WrapErr, bail};
use nanocodex_tools::{
    DEFAULT_TOOL_OUTPUT_TOKENS, ToolContext, ToolOutputBody, ToolOutputContent, ToolRuntime, Tools,
};

const CODE_MODE_SMOKE: &str = r#"
const result = await tools.exec_command({
  cmd: `set -euo pipefail
for program in lean lake z3 cvc5 highs glpsol cbc minizinc cadical kissat gap gp Singular maxima python sage normaliz count; do
  path=$(command -v "$program")
  printf '%s\t%s\n' "$program" "$path"
done
lean --version
z3 -version
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
printf 'example (n : Nat) : n = n := rfl\n' > "$work/Smoke.lean"
lean "$work/Smoke.lean"
printf 'lean-proof\tok\n'
sage -python - <<'PY'
from sage.all import PolynomialRing, QQ
R = PolynomialRing(QQ, "t")
t = R.gen()
assert (t + 1) ** 3 == t**3 + 3*t**2 + 3*t + 1
print("sage-exact-stack\tok")
PY
normaliz --version
cat > "$work/triangle.ine" <<'LATTE'
5 3
1 -1 0
1 0 -1
1 -1 -1
0 1 0
0 0 1
LATTE
(cd "$work" && count triangle.ine > latte.log 2>&1)
test "$(tr -d '[:space:]' < "$work/numOfLatticePoints")" = 3
printf 'latte-count\tok\n'
python - <<'PY'
import cvxpy
import lrcalc
import networkx
import numpy
import scipy
import sympy
import z3
assert lrcalc.lrcoef([3, 2, 1], [2, 1], [2, 1]) == 2
print("python-math-stack\tok")
print("lrcalc-reference\tok")
PY`,
  shell: "bash",
  login: false,
  yield_time_ms: 30000,
  max_output_tokens: 10000
});
text(result);
"#;

#[tokio::main]
async fn main() -> ExitCode {
    match run().await {
        Ok(()) => ExitCode::SUCCESS,
        Err(error) => {
            eprintln!("math environment check failed: {error:#}");
            ExitCode::FAILURE
        }
    }
}

async fn run() -> Result<()> {
    let workspace = env::current_dir().wrap_err("failed to resolve current directory")?;
    let tools = Tools::builder()
        .web_search(false)
        .image_generation(false)
        .build()
        .wrap_err("failed to build lead-equivalent workspace tools")?;
    if !tools.workspace_enabled() {
        bail!("standard workspace tools are disabled");
    }

    let runtime = ToolRuntime::new_with_tools(&workspace, None, None, &tools);
    let history = [];
    let execution = runtime
        .execute_code(
            CODE_MODE_SMOKE,
            ToolContext {
                model: "environment-check",
                session_id: "environment-check",
                call_id: "environment-check",
                history: &history,
                output_token_budget: DEFAULT_TOOL_OUTPUT_TOKENS,
            },
        )
        .await;

    if !execution.success {
        bail!("Code Mode cell failed: {}", body_text(&execution.output));
    }
    let Some(shell_call) = execution
        .nested_calls
        .iter()
        .find(|call| call.name == "exec_command")
    else {
        bail!("Code Mode did not call the exec_command shell tool");
    };
    if !shell_call.success {
        bail!(
            "nested shell call failed: {}",
            body_text(&shell_call.output)
        );
    }
    let output = body_text(&shell_call.output);
    if !output.contains("python-math-stack\\tok")
        || !output.contains("lrcalc-reference\\tok")
        || !output.contains("lean-proof\\tok")
        || !output.contains("sage-exact-stack\\tok")
        || !output.contains("Normaliz 3.11.0")
        || !output.contains("latte-count\\tok")
        || !output.contains("\"exit_code\":0")
    {
        bail!("shell smoke returned incomplete evidence: {output}");
    }

    println!("Code Mode -> exec_command(shell=bash, login=false) succeeded for the LR toolchain.");
    println!("{output}");
    Ok(())
}

fn body_text(body: &ToolOutputBody) -> String {
    match body {
        ToolOutputBody::Text(text) => text.clone(),
        ToolOutputBody::Content(content) => content
            .iter()
            .filter_map(|item| match item {
                ToolOutputContent::InputText { text } => Some(text.as_str()),
                ToolOutputContent::InputImage { .. } => None,
            })
            .collect::<Vec<_>>()
            .join("\n"),
    }
}
