#!/bin/bash

if git submodule status | grep -q '^ +'; then
  echo "Submodules are not updated. Pulling latest..."
  git submodule update --force --recursive --init --remote
else
  echo "Submodules are already up to date."
fi

if ! brew list --versions ansible >/dev/null; then
  echo "Ansible is not installed. Installing..."
  brew install ansible
else
  echo "Ansible is already installed."
fi

if ! brew list --versions yq >/dev/null; then
  echo "yq is not installed. Installing..."
  brew install yq
else
  echo "yq is already installed."
fi

playbook="./playbook.yaml"
playbook_temp="./playbook_temp.yaml"
task_dir="./tasks"

tasks=$(find "$task_dir" -type f -name "*.yaml" -exec basename {} \; | sed 's/\.yaml$//')

IFS=$'\n' read -r -d '' -a tasks_array <<<"$tasks"

echo "Please select a task to run:"
select task in "${tasks_array[@]}"; do
  if [[ -n $task ]]; then
    echo "You selected: $task"
    break
  else
    echo "Invalid selection, please try again."
  fi
done

cp "$playbook" "$playbook_temp"

yq eval ".[0].vars.task_files += [\"$task\"]" -i "$playbook_temp"

ansible-playbook \
  --flush-cache \
  --become-method=sudo \
  --ask-become-pass \
  "$playbook_temp"

trap 'rm "$playbook_temp"; echo "Task execution complete. Temporary playbook removed."' EXIT
