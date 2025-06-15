

# 🧠 Ansible Playbooks: Variables – Explained with Examples

This section demonstrates how to work with variables in Ansible through real examples. Each subfolder in this directory represents a specific use case or feature of Ansible variables.

Let’s walk through each revision from the GitHub examples alongside their explanations:

---

### 🔹 `01-simple-variable`

**Concept**: Declaring a simple key-value variable inside the playbook using `vars`.

```yaml
vars:
  example_key: example_value
```

**Task**:
Print the variable using the `debug` module.

```yaml
- name: Print simple variable
  debug:
    msg: "{{ example_key }}"
```

**Output**:
`ok: [ubuntu-c] => (item=None) => example_value`

---

### 🔹 `02-dictionary`

**Concept**: Using a nested dictionary (YAML-style map).

```yaml
vars:
  dict:
    dictionary_key: dictionary_value
```

**Task**:
Access values in two ways:

```yaml
- debug: msg="{{ dict.dictionary_key }}"
- debug: msg="{{ dict['dictionary_key'] }}"
```

**Output**:
Both yield `dictionary_value`

---

### 🔹 `03-inline-dictionary`

**Concept**: Define a dictionary directly in the task (inline), not under `vars`.

```yaml
- debug:
    msg: "{{ {'dictionary_key': 'dictionary_value'}.dictionary_key }}"
```

**Also works with**:
`{{ {'dictionary_key': 'dictionary_value'}['dictionary_key'] }}`

---

### 🔹 `04-list`

**Concept**: Use a YAML list and access its elements.

```yaml
vars:
  named_list:
    - item1
    - item2
```

**Access by index**:

```yaml
- debug: msg="{{ named_list[0] }}"
- debug: msg="{{ named_list.0 }}"
```

---

### 🔹 `05-inline-list`

**Concept**: Define and access a list directly inside a task.

```yaml
- debug:
    msg: "{{ ['item1', 'item2'][0] }}"
```

---

### 🔹 `06-vars-file`

**Concept**: Load external variables from a file.

```yaml
vars_files:
  - external_vars.yaml
```

`external_vars.yaml`:

```yaml
example_key: from_file
named_list:
  - file_item1
  - file_item2
```

**Result**:
Same debug syntax prints values from the file.

---

### 🔹 `07-vars-prompt`

**Concept**: Prompt user input at runtime.

```yaml
vars_prompt:
  - name: "username"
    prompt: "Enter your username"
    private: no
```

**Result**:
Prompts `Enter your username:` and shows input in task result.

---

### 🔹 `08-vars-prompt-private`

**Concept**: Masked input (e.g., passwords).

```yaml
vars_prompt:
  - name: "password"
    prompt: "Enter your password"
    private: yes
```

**Result**:
Password is not shown while typing but is usable in playbook.

---

### 🔹 `09-hostvars`

**Concept**: Access a variable set for a specific host from another host using `hostvars`.

```yaml
- debug:
    msg: "{{ hostvars[inventory_hostname].ansible_port }}"
```

---

### 🔹 `10-missing-vars-error`

**Concept**: Accessing a variable that is not defined causes an error for other hosts.

**Fix**:
Use a filter to provide a default.

---

### 🔹 `11-default-filter`

**Concept**: Use Jinja2 `default()` filter to avoid undefined variable errors.

```yaml
- debug:
    msg: "{{ hostvars[inventory_hostname].ansible_port | default(22) }}"
```

**Result**:
If `ansible_port` is not defined, it defaults to `22`.

---

### 🔹 `12-group-vars`

**Concept**: Define common variables for a group inside `group_vars/centos`.

```yaml
ansible_user: root
```

**Result**:
All hosts in the `centos` group will use this variable.

---

### 🔹 `13-host-vars-error`

**Concept**: If host-specific variables aren't set, it leads to runtime errors.

---

### 🔹 `14-groupvar-access-via-hostvars`

**Concept**: Even if a variable is a group var, you can access it via `hostvars`.

```yaml
- debug:
    msg: "{{ hostvars['centos1'].ansible_user }}"
```

---

### 🔹 `15-command-line-vars`

**Concept**: Pass variables using CLI

```bash
ansible-playbook playbook.yml -e "key1=value1 key2=value2"
```

---

### 🔹 `16-json-vars`

**Concept**: Pass CLI variables as JSON

```bash
ansible-playbook playbook.yml -e '{"key1":"value1"}'
```

---

### 🔹 `17-file-vars-json-or-yaml`

**Concept**: Pass variable file in JSON or YAML format

```bash
ansible-playbook playbook.yml -e "@vars.yaml"
ansible-playbook playbook.yml -e "@vars.json"
```

---

### 🔹 `18-group_vars_directory`

**Concept**: Use `group_vars/<groupname>.yml` to auto-load group-specific values.

Example: `group_vars/centos.yml`

```yaml
ansible_user: root
```

---

### 🔹 `19-host_vars_directory`

**Concept**: Use `host_vars/<hostname>.yml` to define host-specific variables.

Example: `host_vars/ubuntu-c.yml`

```yaml
ansible_connection: local
```

---
Here is the **revised summary table** with columns for **Concept**, **Explanation**, and **Example Folder** from your GitHub repo:

---

### ✅ Ansible Variables – Summary Table

| **Concept**                  | **Explanation**                                                        | **Example Folder**                |
| ---------------------------- | ---------------------------------------------------------------------- | --------------------------------- |
| Simple Variable              | Define a single key-value pair directly in `vars` block                | `01-simple-variable`              |
| Dictionary Variable          | Use nested key-value pairs; access via dot or bracket notation         | `02-dictionary`                   |
| Inline Dictionary            | Declare a dictionary directly in the task instead of `vars`            | `03-inline-dictionary`            |
| List Variable                | Define a list of values and access items using index                   | `04-list`                         |
| Inline List                  | Use a list inside the task definition itself                           | `05-inline-list`                  |
| External Variables File      | Load variables from a YAML file using `vars_files`                     | `06-vars-file`                    |
| Prompt for Variable          | Use `vars_prompt` to ask for values during execution                   | `07-vars-prompt`                  |
| Prompt with Hidden Input     | Mask input during variable prompt (e.g., password)                     | `08-vars-prompt-private`          |
| Access Host Variables        | Use `hostvars` to fetch variables from other hosts                     | `09-hostvars`                     |
| Missing Variables Error      | Referencing undefined variables causes errors                          | `10-missing-vars-error`           |
| Default Filter               | Use `default` filter to set fallback values for missing variables      | `11-default-filter`               |
| Group Variables              | Assign shared values to all hosts in a group using `group_vars/`       | `12-group-vars`                   |
| Host Variables Missing       | Shows error when a variable is expected but not defined per host       | `13-host-vars-error`              |
| Access GroupVar via HostVars | Group variables are accessible via `hostvars` for a specific host      | `14-groupvar-access-via-hostvars` |
| Extra Vars - CLI (INI)       | Pass variables inline with `-e` flag on CLI using INI-style syntax     | `15-command-line-vars`            |
| Extra Vars - CLI (JSON)      | Pass variables using JSON string on the CLI                            | `16-json-vars`                    |
| Extra Vars - File Input      | Load variables from a file (YAML or JSON) via `-e "@file"`             | `17-file-vars-json-or-yaml`       |
| Group Vars Directory         | Automatically load variables for a group from `group_vars/` directory  | `18-group_vars_directory`         |
| Host Vars Directory          | Automatically load host-specific variables from `host_vars/` directory | `19-host_vars_directory`          |

---

Here are **detailed interview questions and answers** based on the Ansible Variables concepts you studied and implemented with examples from your GitHub repo.

---

### ✅ **Interview Questions and Answers for Ansible Variables**

---

#### 1. **Q: How do you define and use a simple variable in Ansible?**

**A:**
A simple variable is defined as a key-value pair under the `vars:` section in a playbook. It can be accessed using `{{ variable_name }}` syntax.

**Example:**

```yaml
vars:
  example_key: "example_value"
```

Usage:

```yaml
- debug:
    msg: "{{ example_key }}"
```

🗂️ **Reference:** [`01-simple-variable`](https://github.com/ANSANJAY/diveintoansible/tree/master/Ansible%20Playbooks%2C%20Introduction/Ansible%20Playbooks%2C%20Variables/01-simple-variable)

---

#### 2. **Q: What is a dictionary variable and how do you access nested keys in Ansible?**

**A:**
A dictionary variable contains key-value pairs inside another key. Nested values can be accessed using either dot notation (`dict.key`) or bracket notation (`dict['key']`).

**Example:**

```yaml
vars:
  dict:
    nested_key: "nested_value"
```

Usage:

```yaml
- debug: msg: "{{ dict.nested_key }}"
- debug: msg: "{{ dict['nested_key'] }}"
```

🗂️ **Reference:** [`02-dictionary`](https://github.com/ANSANJAY/diveintoansible/tree/master/Ansible%20Playbooks%2C%20Introduction/Ansible%20Playbooks%2C%20Variables/02-dictionary)

---

#### 3. **Q: How can you use inline dictionaries and lists in tasks?**

**A:**
Inline variables allow defining dictionaries or lists directly inside the task, which helps simplify temporary data usage.

**Example (Inline Dictionary):**

```yaml
- debug: msg: "{{ {'key': 'value'}.key }}"
```

**Example (Inline List):**

```yaml
- debug: msg: "{{ ['item1', 'item2'][0] }}"
```

🗂️ **Reference:** [`03-inline-dictionary`](#), [`05-inline-list`](#)

---

#### 4. **Q: How do you load variables from an external YAML file?**

**A:**
You can load external variables using the `vars_files` directive in a playbook.

**Example:**

```yaml
vars_files:
  - external_vars.yaml
```

🗂️ **Reference:** [`06-vars-file`](#)

---

#### 5. **Q: What is `vars_prompt` and how is it useful?**

**A:**
`vars_prompt` is used to interactively collect values from the user during playbook execution. You can mask sensitive input using `private: yes`.

```yaml
vars_prompt:
  - name: "username"
    prompt: "Enter your username"
    private: no

  - name: "password"
    prompt: "Enter your password"
    private: yes
```

🗂️ **Reference:** [`07-vars-prompt`](#), [`08-vars-prompt-private`](#)

---

#### 6. **Q: What is `hostvars` and how do you access variables of another host?**

**A:**
`hostvars` is a magic variable that holds all variable information for all hosts in inventory. You can use it to access data from another host.

```yaml
- debug:
    msg: "{{ hostvars['centos1'].ansible_port }}"
```

🗂️ **Reference:** [`09-hostvars`](#)

---

#### 7. **Q: What happens when a variable is missing during execution?**

**A:**
Ansible will throw an error if you try to use a variable that hasn’t been defined—unless you provide a default value using a Jinja2 filter.

```yaml
- debug: msg: "{{ hostvars['centos2'].ansible_port | default(22) }}"
```

🗂️ **Reference:** [`10-missing-vars-error`](#), [`11-default-filter`](#)

---

#### 8. **Q: How do you define group and host-level variables?**

**A:**

* Group variables are defined in `group_vars/<groupname>.yml`
* Host variables are defined in `host_vars/<hostname>.yml`

Ansible automatically loads these when it sees matching folder names.

🗂️ **Reference:** [`18-group_vars_directory`](#), [`19-host_vars_directory`](#)

---

#### 9. **Q: How can you override variables using extra vars?**

**A:**
You can pass variables via the CLI using the `-e` flag.

**INI-style:**

```bash
ansible-playbook playbook.yml -e "var1=value1"
```

**JSON-style:**

```bash
ansible-playbook playbook.yml -e '{"var1": "value1"}'
```

**YAML-style:**

```bash
ansible-playbook playbook.yml -e "@vars.yaml"
```

🗂️ **Reference:** [`15-command-line-vars`](#), [`16-json-vars`](#), [`17-file-vars-json-or-yaml`](#)

---

#### 10. **Q: What is the precedence order of variable definitions in Ansible?**

**A:**
From highest to lowest:

1. Extra vars (`-e`)
2. Task vars
3. Block vars
4. Role and include vars
5. Inventory vars (host/group)
6. Facts
7. Registered vars
8. Play vars
9. Vars files
10. Default vars in roles

---


