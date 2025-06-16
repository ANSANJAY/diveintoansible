## ✅ Concept: Register and When in Ansible

### 🔹 Simple Explanation

| **Concept** | **Explanation**                                                                                                                       |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `register`  | Used to **store the result/output** of a task in a variable. You can later **refer to this result** in other tasks.                   |
| `when`      | A **conditional check** that tells Ansible to run a task **only if a certain condition is met**. Often used with facts or `register`. |

---

## 🧠 Real-World Analogy

Imagine you're a **chef** in a smart kitchen.

* You run a **temperature check** (`command`) and store the result in a sensor log (`register`).
* Then, you say:
  “**If** the temperature is above 180°C (`when condition`), start baking the cake.”

---

## 🧪 Real-World Scenario

You're managing multiple servers, some are Ubuntu, others CentOS. You need to:

* Run a command and check the result.
* Install a package only **if the command was successful**.
* Apply different behavior for different OS types.

Here’s how `register` and `when` help:

* `register` captures the output (stdout, stderr, return code).
* `when` uses conditions based on:

  * facts (`ansible_distribution`)
  * command results (`hostname_output.changed == true`)
  * skipped status
  * or boolean comparisons

---

## 💡 Examples from Your Repo

 Here’s a **side-by-side breakdown**:

| **Snippet**                                                                                                                                        | **Explanation**                                                                      |                                           |
| -------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ | ----------------------------------------- |
| `yaml<br>- name: Get hostname<br>  command: hostname<br>  register: hostname_output<br>`                                                           | Captures the output of the `hostname` command in a variable named `hostname_output`. |                                           |
| `yaml<br>- name: Print only stdout<br>  debug:<br>    var: hostname_output.stdout<br>`                                                             | Shows the actual hostname (i.e., what the command returned).                         |                                           |
| \`\`\`yaml<br>- name: Install patch on CentOS<br>  when:<br>    - ansible\_distribution == "CentOS"<br>    - ansible\_distribution\_major\_version | int >= 8<br>\`\`\`                                                                   | Uses conditional execution for CentOS 8+. |
| `yaml<br>- name: Install patch if command changed<br>  when: hostname_output.changed<br>`                                                          | Installs package only if previous command resulted in changes.                       |                                           |

---

## 🧪 Filters & Best Practices

| **Usage**                      | **What It Does**                                                |
| ------------------------------ | --------------------------------------------------------------- |
| `.stdout`                      | Captures the standard output (i.e., actual command result)      |
| `.rc`                          | Return code from command (0 = success)                          |
| `.stderr`                      | Any error printed                                               |
| `.changed`                     | Boolean: Did anything change?                                   |
| `is skipped` / `is changed`    | Clean syntax for condition checks                               |
| Combine `when` with `register` | Filter execution logic based on command success, skip, or error |

---

## 🧩 Advanced Conditions

You can write:

```yaml
when:
  - ansible_distribution == "Ubuntu"
  - ansible_distribution_major_version | int >= 20
```

Or:

```yaml
when: 
  command_result.changed
```

Or:

```yaml
when: not command_result.skipped
```

---

## ❓ Interview Questions + Sample Answers

### 1. **What is the purpose of `register` in Ansible?**

> The `register` directive stores the result of a task (like a command) into a variable. This result includes stdout, stderr, return code, and whether the task changed the state.

---

### 2. **What kind of information is stored in a registered variable?**

> It stores a dictionary with keys like `stdout`, `stderr`, `rc` (return code), `changed`, and `stdout_lines`. These help us evaluate the task outcome and use it in subsequent logic.

---

### 3. **How is `when` used with `register`?**

> After capturing command output using `register`, we use `when` to run further tasks only if certain conditions are true — for example, only if `command_output.changed` or `command_output.rc == 0`.

---

### 4. **What’s the advantage of using `stdout_lines`?**

> `stdout_lines` splits multiline output into a list, making it easier to loop through or match individual values.

---

### 5. **Can you use `when` with facts like `ansible_distribution`?**

> Yes. You can conditionally run tasks based on system facts such as `ansible_distribution`, `ansible_os_family`, or major version — which helps with OS-aware automation.

---

### 6. **How would you write a task that installs a package only if a previous command succeeded?**

```yaml
- name: Run a command
  command: some-command
  register: result

- name: Install package if previous succeeded
  yum:
    name: patch
    state: present
  when: result.rc == 0
```

---

