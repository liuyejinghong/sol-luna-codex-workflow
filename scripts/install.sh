#!/usr/bin/env bash
set -euo pipefail

installer_script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
installer_repo_root="$(cd -- "${installer_script_dir}/.." && pwd)"
installer_home_dir="${HOME:?HOME is not set}"

if [[ "${installer_home_dir}" != /* ]]; then
  echo "Error: HOME must be an absolute path: ${installer_home_dir}" >&2
  exit 1
fi

if [[ -n "${CODEX_HOME:-}" ]]; then
  installer_codex_dir="${CODEX_HOME}"
else
  installer_codex_dir="${installer_home_dir}/.codex"
fi

if [[ "${installer_codex_dir}" != /* ]]; then
  echo "Error: Codex home must be an absolute path: ${installer_codex_dir}" >&2
  exit 1
fi

installer_agent_source="${installer_repo_root}/agents/luna-worker.toml"
installer_skill_source="${installer_repo_root}/skills/sol-luna-workflow/SKILL.md"
installer_agent_target="${installer_codex_dir}/agents/luna-worker.toml"
installer_skill_target="${installer_home_dir}/.agents/skills/sol-luna-workflow/SKILL.md"
installer_legacy_skill_dir="${installer_codex_dir}/skills/sol-luna-workflow"
installer_legacy_skill_target="${installer_legacy_skill_dir}/SKILL.md"
installer_conflict=0

for installer_pair in \
  "${installer_agent_source}|${installer_agent_target}" \
  "${installer_skill_source}|${installer_skill_target}"
do
  installer_source="${installer_pair%%|*}"
  installer_target="${installer_pair#*|}"
  if [[ ( -e "${installer_target}" || -L "${installer_target}" ) ]] && ! cmp -s "${installer_source}" "${installer_target}"; then
    echo "Conflict: ${installer_target} already exists with different content." >&2
    installer_conflict=1
  fi
done

if [[ -L "${installer_legacy_skill_dir}" || -L "${installer_legacy_skill_target}" ]]; then
  echo "Conflict: legacy Skill path uses a symbolic link and requires manual migration: ${installer_legacy_skill_dir}" >&2
  installer_conflict=1
elif [[ -e "${installer_legacy_skill_target}" ]] && ! cmp -s "${installer_skill_source}" "${installer_legacy_skill_target}"; then
  echo "Conflict: ${installer_legacy_skill_target} already exists with different content." >&2
  installer_conflict=1
fi

if [[ "${installer_conflict}" -ne 0 ]]; then
  echo "No files were changed. Resolve the conflict explicitly, then run the installer again." >&2
  exit 2
fi

mkdir -p -- "${installer_codex_dir}/agents" "$(dirname -- "${installer_skill_target}")"

if [[ ! -e "${installer_agent_target}" && ! -L "${installer_agent_target}" ]]; then
  install -m 0644 "${installer_agent_source}" "${installer_agent_target}"
  echo "Installed: ${installer_agent_target}"
else
  echo "Unchanged: ${installer_agent_target}"
fi

if [[ ! -e "${installer_skill_target}" && ! -L "${installer_skill_target}" ]]; then
  install -m 0644 "${installer_skill_source}" "${installer_skill_target}"
  echo "Installed: ${installer_skill_target}"
else
  echo "Unchanged: ${installer_skill_target}"
fi

cmp -s "${installer_agent_source}" "${installer_agent_target}"
cmp -s "${installer_skill_source}" "${installer_skill_target}"

if [[ -e "${installer_legacy_skill_target}" ]]; then
  rm -- "${installer_legacy_skill_target}"
  rmdir -- "${installer_legacy_skill_dir}" 2>/dev/null || true
  echo "Migrated: removed identical legacy Skill at ${installer_legacy_skill_target}"
fi

echo "Verified: installed files match the repository sources."
echo "Manual step: paste one block from ${installer_repo_root}/personalization.md into Codex App Settings > Personalization > Custom Instructions."
