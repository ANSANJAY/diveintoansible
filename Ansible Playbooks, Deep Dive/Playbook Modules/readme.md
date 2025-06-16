

### ✅ 1. `set_fact` Module

**What it does:**
Allows you to create new variables (facts) dynamically during playbook execution.

**Example:**

```yaml
- name: Set a custom fact
  set_fact:
    our_fact: "Ansible Rocks!"
```

**Why it's useful:**
You can conditionally set variables without needing group\_vars or host\_vars.

**Example Output:**

```yaml
"our_fact": "Ansible Rocks!"
```

---

### ✅ 2. Overwriting or Modifying Multiple Facts

```yaml
- name: Set multiple facts and transform text
  set_fact:
    our_fact: "Ansible Rocks!"
    ansible_distribution: "{{ ansible_distribution | upper }}"
```

**Explanation:**

* `ansible_distribution` is normally something like `ubuntu`.
* Using `| upper` turns it into `UBUNTU`.

---

### ✅ 3. Conditional `set_fact` Based on OS

**Why:**
Useful for OS-specific path differences.

```yaml
- name: Set web path based on OS
  set_fact:
    web_root: "/var/www/html"
  when: ansible_distribution == "Ubuntu"

- name: Set web path for CentOS
  set_fact:
    web_root: "/usr/share/nginx/html"
  when: ansible_distribution == "CentOS"
```

---

### ✅ 4. `pause` Module

**What it does:**
Pauses the playbook for a fixed time or until a key is pressed.

```yaml
- name: Pause for 5 seconds
  pause:
    seconds: 5
```

**With user input:**

```yaml
- name: Prompt for user to continue
  pause:
    prompt: "Please confirm that deployment is ready. Press Enter to continue."
```

---

### ✅ 5. `wait_for` Module

**What it does:**
Waits for a service or port to be ready (great for checking web servers).

```yaml
- name: Wait for port 80 (HTTP) to be open
  wait_for:
    port: 80
    delay: 5
    timeout: 30
```

---

### ✅ 6. `assemble` Module

**What it does:**
Combines multiple small config files into one big file.

```yaml
- name: Assemble configs
  assemble:
    src: conf.d/
    dest: /tmp/sshd_config
```

**When to use:**
You have separate config snippets for each host or feature.

---

### ✅ 7. `add_host` Module

**What it does:**
Dynamically adds hosts to a new group during runtime.

```yaml
- name: Add host to adhoc group
  add_host:
    name: centos1
    groups: adhoc_group1
```

**Then target it:**

```yaml
- hosts: adhoc_group1
  tasks:
    - name: Ping dynamically added host
      ping:
```

---

### ✅ 8. `group_by` Module

**What it does:**
Creates groups based on facts, like OS type.

```yaml
- name: Group by distribution
  group_by:
    key: "custom_{{ ansible_distribution | lower }}"
```

**Why:**
Later target only `custom_ubuntu` or `custom_centos`.

---

### ✅ 9. `fetch` Module

**What it does:**
Fetches a file from remote hosts and saves it locally.

```yaml
- name: Fetch redhat release info
  fetch:
    src: /etc/redhat-release
    dest: /tmp/redhat-release/
```

**Local Structure Output:**

```
/tmp/redhat-release/centos1/etc/redhat-release
```

---

### 🧠 Summary Table

| Module     | Purpose                           | Use Case                    |
| ---------- | --------------------------------- | --------------------------- |
| `set_fact` | Set custom variables              | Set web paths based on OS   |
| `pause`    | Pause execution                   | Manual confirmation         |
| `wait_for` | Wait for port/service to be ready | Wait for web server startup |
| `assemble` | Combine multiple files            | SSH config snippets         |
| `add_host` | Add host to group dynamically     | Multi-stage playbooks       |
| `group_by` | Group hosts based on facts        | OS-based automation         |
| `fetch`    | Copy remote files to local        | Collect logs/configs        |

---


## 🧠 Simple Explanation: Ansible Playbook Modules

Ansible Playbook Modules are **prebuilt building blocks** that help you perform tasks in automation scripts—like setting variables, pausing execution, checking services, fetching files, and managing dynamic groups of servers.
Think of them like **tools in a toolbox**, each serving a specific purpose during the execution of a playbook.


## 🎯 Interview Questions & Sample Answers

### 1. **What is `set_fact` and when would you use it?**

**Answer:**
`set_fact` is an Ansible module used to define or override variables during playbook execution. It’s useful for setting dynamic values based on conditions, such as OS type or environment. For example, setting `web_root` differently for Ubuntu (`/var/www/html`) and CentOS (`/usr/share/nginx/html`).

---

### 2. **How does `pause` improve playbook control?**

**Answer:**
`pause` halts execution for a specified time or until user input is given. It’s commonly used when manual validation is required—e.g., waiting for a team to complete a task, or verifying a config before proceeding.

---

### 3. **What problem does `wait_for` solve?**

**Answer:**
It ensures that a condition—like a port being open or service being ready—is met before continuing. For instance, if a web server is starting up, `wait_for` ensures port 80 is active before health checks run.

---

### 4. **What is the use of the `assemble` module?**

**Answer:**
It assembles multiple files into one large file. This is useful in managing large, modular config files—for example, merging separate SSH config parts into a final `/etc/ssh/sshd_config`.

---

### 5. **Can you dynamically add hosts during playbook execution?**

**Answer:**
Yes, using the `add_host` module. This allows tasks to register a new host (e.g., discovered dynamically or from an API), and include it in later plays.

---

### 6. **When would you use `group_by`?**

**Answer:**
To group hosts based on a fact like OS type, environment, etc. You could use `group_by` to automatically create `custom_ubuntu` and `custom_centos` groups to apply specific roles.

---

### 7. **What’s the difference between `fetch` and `copy` modules?**

**Answer:**

* `copy` pushes files **from controller to remote**.
* `fetch` pulls files **from remote to controller**.
  Useful in cases like gathering logs or system files for backup or audit.

---

## ✅ Wrap-Up Summary

Ansible Playbook Modules give your automation scripts **flexibility and control**. You can dynamically:

* Create variables (`set_fact`)
* Pause for checks (`pause`)
* Wait for readiness (`wait_for`)
* Manage config files (`assemble`)
* Add and group hosts (`add_host`, `group_by`)
* Collect info from servers (`fetch`)

They’re like smart switches in your playbook that help **respond to conditions** and **adapt on the fly**—making automation resilient and production-grade.


Here is a structured breakdown of each module example in your `Playbook Modules` directory on GitHub:

---

# 📘 Ansible Playbook Modules – Deep Dive

This directory demonstrates various types of **Ansible modules** used within playbooks. Each folder represents a module with real-world examples. Below is a detailed explanation for each.

---

## 🔹 01-copy

### ✅ Module Type:

**File module** – used to copy files from control node to managed hosts.

### 🌐 Real-World Usage:

| Use Case                   | Description                                  |
| -------------------------- | -------------------------------------------- |
| Deploy configuration files | Push config templates to web or app servers  |
| Upload shell scripts       | Provision and run custom init scripts on VMs |
| Static file distribution   | Copy license files, SSL certs, etc.          |

### 💬 Interview Questions:

1. How does the `copy` module handle idempotency?

   > It checks file checksum before replacing the destination.

2. What happens if the source file is missing?

   > The task fails unless `ignore_errors: yes` is set.

---

## 🔹 02-file

### ✅ Module Type:

**File module** – manages file attributes (ownership, permissions, symlink, etc.)

### 🌐 Real-World Usage:

| Use Case           | Description                             |
| ------------------ | --------------------------------------- |
| Set permissions    | Ensure critical files have correct mode |
| Create directories | Safely make idempotent directory trees  |
| Create symlinks    | Link to shared folders, binaries        |

### 💬 Interview Questions:

1. What states are supported by the `file` module?

   > `file`, `directory`, `link`, `absent`, etc.

2. Can `file` change content of a file?

   > No, only file properties like mode, owner, etc.

---

## 🔹 03-lineinfile

### ✅ Module Type:

**Text manipulation module** – ensures a line is present/absent in a file.

### 🌐 Real-World Usage:

| Use Case                | Description                                     |
| ----------------------- | ----------------------------------------------- |
| Modify configs          | Ensure settings exist in `/etc/ssh/sshd_config` |
| Disable/enable services | Toggle lines in init files                      |
| Patch application files | Insert or update key values                     |

### 💬 Interview Questions:

1. How is `lineinfile` different from `blockinfile`?

   > `lineinfile` manages single lines; `blockinfile` manages groups.

2. How to use regex with `lineinfile`?

   > Use `regexp:` to match and replace a line.

---

## 🔹 04-blockinfile

### ✅ Module Type:

**Text manipulation module** – adds a text block between custom markers.

### 🌐 Real-World Usage:

| Use Case                    | Description                             |
| --------------------------- | --------------------------------------- |
| Inject virtual host configs | Block of config in nginx/apache files   |
| Add managed code safely     | Insert reusable blocks without clashing |
| Configuration templates     | Embed repeatable section with tags      |

### 💬 Interview Questions:

1. Why use `blockinfile` over `copy`?

   > Preserves manual edits and integrates with existing files.

2. What are the default block markers?

   > `BEGIN ANSIBLE MANAGED BLOCK` and `END ANSIBLE MANAGED BLOCK`

---

## 🔹 05-replace

### ✅ Module Type:

**Text manipulation module** – replaces patterns using regular expressions.

### 🌐 Real-World Usage:

| Use Case                  | Description                                     |
| ------------------------- | ----------------------------------------------- |
| Disable settings          | Replace `PermitRootLogin yes` with `no`         |
| Change hardcoded values   | Modify file paths, ports, credentials in config |
| Clean up deprecated lines | Replace or comment outdated lines               |

### 💬 Interview Questions:

1. Can `replace` work without `regexp`?

   > No, regex is mandatory to match lines.

2. What’s a safe way to use it?

   > Always test regex to avoid unintended replacements.

---

## 🔹 06-template

### ✅ Module Type:

**Templating module** – renders `.j2` files with variables using Jinja2.

### 🌐 Real-World Usage:

| Use Case                | Description                              |
| ----------------------- | ---------------------------------------- |
| Generate configs        | Nginx, Apache, Systemd, app config files |
| Inject env variables    | Substitute dynamic values during runtime |
| Parameterized templates | Reusable playbooks for different roles   |

### 💬 Interview Questions:

1. How does `template` handle variable injection?

   > Through Jinja2 syntax like `{{ variable_name }}`.

2. Difference between `copy` and `template`?

   > `copy` sends static files; `template` dynamically renders content.

---

## 🔹 07-fetch

### ✅ Module Type:

**File retrieval module** – copies files from remote hosts to controller.

### 🌐 Real-World Usage:

| Use Case             | Description                                       |
| -------------------- | ------------------------------------------------- |
| Collect logs         | Pull logs from remote servers post-deployment     |
| Retrieve backups     | Download `.conf`, `.sql`, `.tar.gz` to local host |
| Post-run diagnostics | Fetch crash dumps, output files                   |

### 💬 Interview Questions:

1. Does `fetch` preserve remote path structure?

   > Yes, it nests directories under hostname.

2. How to flatten file output?

   > Use `flat: yes` in the task.

---

## 🔹 08-unarchive

### ✅ Module Type:

**File module** – unpacks `.tar`, `.zip`, etc. on remote hosts.

### 🌐 Real-World Usage:

| Use Case            | Description                              |
| ------------------- | ---------------------------------------- |
| Deploy apps         | Unpack tarballs with app code or configs |
| Distribute binaries | Extract custom binaries and scripts      |
| Vendor packages     | Unzip driver, agent, tool packages       |

### 💬 Interview Questions:

1. Can it unzip a file already on the target?

   > Yes, using `src:` without `copy:`.

2. How to unzip from controller to remote?

   > Set `copy: yes` and point `src:` to controller path.

---

## 📦 Summary Table

| Module        | Type          | Use Case                                |
| ------------- | ------------- | --------------------------------------- |
| `copy`        | File mgmt     | Push static files to target machines    |
| `file`        | File props    | Ensure path, mode, ownership            |
| `lineinfile`  | Text editor   | Ensure lines exist or are modified      |
| `blockinfile` | Block insert  | Insert template blocks with markers     |
| `replace`     | Regex replace | Search and replace patterns             |
| `template`    | Jinja2 render | Render files dynamically with variables |
| `fetch`       | Retrieval     | Pull files from remote to controller    |
| `unarchive`   | Unzip tool    | Extract files on the target machines    |

---



