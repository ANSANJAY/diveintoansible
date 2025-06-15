
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

Here's a simplified explanation of **Ansible Playbook Modules**, real-world examples for each, and relevant interview questions with answers:

---

## 🧠 Simple Explanation: Ansible Playbook Modules

Ansible Playbook Modules are **prebuilt building blocks** that help you perform tasks in automation scripts—like setting variables, pausing execution, checking services, fetching files, and managing dynamic groups of servers.
Think of them like **tools in a toolbox**, each serving a specific purpose during the execution of a playbook.

---

## 🔧 Real-World Examples + Easy Concept Explanation

| 📘 **Module** | 🧾 **Simple Explanation**                                      | 🌍 **Real-World Example**                                                                               |
| ------------- | -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| `set_fact`    | Temporarily creates or overrides variables during execution.   | You want different web server paths for Ubuntu and CentOS in your playbook. Set this value dynamically. |
| `pause`       | Pauses the playbook for a few seconds or waits for user input. | During deployment, you may want the user to verify something manually before continuing.                |
| `wait_for`    | Waits until a condition like port/service availability is met. | Wait until Nginx starts and port 80 is open before hitting it with curl or health check.                |
| `assemble`    | Joins multiple config files into one big config file.          | You maintain SSH config snippets per host, and need to merge them before deploying.                     |
| `add_host`    | Adds a host to a new group during playbook run.                | A script dynamically discovers new VMs and you want to run some tasks only on them.                     |
| `group_by`    | Groups hosts based on conditions/facts.                        | Group servers into `custom_ubuntu` or `custom_centos` to perform OS-specific tasks.                     |
| `fetch`       | Retrieves files from remote systems and stores them locally.   | Pull logs or system info (like `/etc/redhat-release`) from all servers for audit/reporting.             |

---

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

