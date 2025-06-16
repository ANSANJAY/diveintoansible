
### ✅ Revision 0 – Basic Nginx Install Task for CentOS and Ubuntu (YUM/APT Based)

| Code Snippet                                                                                                                                                                    | Explanation                                                                                                                                                                              |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `yaml<br>- name: Install EPEL repo on CentOS<br>  yum:<br>    name: epel-release<br>    state: latest<br>    update_cache: yes<br>  when: ansible_distribution == "CentOS"<br>` | Installs the EPEL repository **only on CentOS** machines using the `yum` module. This is needed to install `nginx` on CentOS-based systems. Uses a `when` clause based on Ansible facts. |
| `yaml<br>- name: Install Nginx on CentOS<br>  yum:<br>    name: nginx<br>    state: latest<br>    update_cache: yes<br>  when: ansible_distribution == "CentOS"<br>`            | Installs `nginx` on CentOS. Ensures that the playbook is **idempotent** and runs only on the appropriate hosts.                                                                          |
| `yaml<br>- name: Install Nginx on Ubuntu<br>  apt:<br>    name: nginx<br>    state: latest<br>    update_cache: yes<br>  when: ansible_distribution == "Ubuntu"<br>`            | Uses the `apt` module to install nginx on Ubuntu systems. Mirrors the CentOS logic but with Ubuntu’s package manager.                                                                    |

---

### ✅ Revision 1 – Simplifying with the `package` Module

| Code Snippet                                                                                                           | Explanation                                                                                                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `yaml<br>- name: Install Nginx using generic package module<br>  package:<br>    name: nginx<br>    state: latest<br>` | Replaces the two separate tasks for Ubuntu and CentOS with a **single task** using the `package` module. This is platform-agnostic – Ansible handles the underlying package manager (`yum`, `dnf`, `apt`). Great for **DRY** (Don’t Repeat Yourself) code. |

---

### ✅ Revision 2 – Restart Nginx Using Service Module

| Code Snippet                                                                                                                 | Explanation                                                                                                                                                    |
| ---------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `yaml<br>- name: Restart nginx<br>  service:<br>    name: nginx<br>    state: restarted<br>  notify: check HTTP service<br>` | Ensures `nginx` is restarted on all hosts and **notifies a handler** that will verify HTTP availability. Using `state: restarted` forces a restart every time. |

---

### ✅ Revision 3 – Handler to Validate with `uri` Module

| Code Snippet                                                                                                                                            | Explanation                                                                                                                                                                                         |
| ------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `yaml<br>handlers:<br>  - name: check HTTP service<br>    uri:<br>      url: "http://{{ ansible_default_ipv4.address }}"<br>      status_code: 200<br>` | The `uri` module sends an HTTP GET to the local server to ensure `nginx` is responding with a **200 OK**. This confirms successful deployment and is triggered only if the task changes (`notify`). |

---

### ✅ Revision 4 – Jinja2 Template with Group Variables

| Code Snippet                                                                                                                                                       | Explanation                                                                                                                                                                                       |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `yaml<br>- name: Deploy custom HTML<br>  template:<br>    src: index.html.j2<br>    dest: "{{ nginx_root_dir }}/index.html"<br>    mode: '0644'<br>`               | Uses the `template` module to deploy a Jinja2-rendered HTML page. The destination path is customized using a group variable (`nginx_root_dir`) defined per OS (Ubuntu or CentOS) in `group_vars`. |
| Example `group_vars/centos.yaml`<br>`yaml<br>nginx_root_dir: /usr/share/nginx/html<br>`<br>`group_vars/ubuntu.yaml`<br>`yaml<br>nginx_root_dir: /var/www/html<br>` | OS-specific root paths for serving the web content. Allows a single template task to work across both OS types.                                                                                   |

---

### ✅ Revision 5 – Ansible Managed Marker in Templates

| Code Snippet                                        | Explanation                                                                                                                                                                                      |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `html<br><!-- Managed by {{ ansible_managed }} -->` | Automatically injects metadata (file name, user, host) into the file using the built-in `ansible_managed` variable. Useful for audit, traceability, and preventing manual edits to config files. |

---

### ✅ Revision 6 – Adding Dynamic Logos with `vars_files`

| Code Snippet                                                                                                        | Explanation                                                                       |
| ------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| `yaml<br>vars_files:<br>  - vars/logos.yml<br>`<br>`yaml<br>centos_logo: centos.png<br>ubuntu_logo: ubuntu.png<br>` | Loads a YAML file with per-OS logo mappings.                                      |
| `html<br><img src="{{ centos_logo if ansible_distribution == 'CentOS' else ubuntu_logo }}" />`                      | Dynamically sets the image source in the web page using Jinja2 conditional logic. |

---

### ✅ Revision 7 – Deploy an Easter Egg Web Game

| Code Snippet                                                                                                                                                                     | Explanation                                                                                                                               |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `yaml<br>- name: Unarchive Playbook Stacker<br>  unarchive:<br>    src: playbook_stacker.zip<br>    dest: "{{ nginx_root_dir }}"<br>    remote_src: yes<br>    mode: '0755'<br>` | Extracts a zip file containing the Playbook Stacker game directly into the web server directory. This is a fun way to show extensibility. |
| `html<br><a href="playbook_stacker/index.html"><img src="{{ logo }}" /></a>`                                                                                                     | Makes the logo a clickable link to the Easter egg game, merging templating and static content deployment.                                 |


# Deploying NGINX + Website with Ansible (CentOS & Ubuntu)

This example project demonstrates an end-to-end Ansible playbook that:
- Installs `nginx` on both Ubuntu and CentOS hosts.
- Uses **facts** to make platform-aware decisions.
- Templates website content using **Jinja2**.
- Adds **handlers**, **Ansible managed** metadata, **group variables**, and even a hidden Easter egg game!

---

## 🔸 Summary Table

| Concept                         | Explanation                                                                 | Example File / Ref |
|-------------------------------|-----------------------------------------------------------------------------|---------------------|
| Conditional Package Install     | Use `when` clause with facts like `ansible_distribution`.                  | `rev1-install-epel.yml` |
| Platform-aware NGINX Install    | Use `yum`, `dnf`, or `apt` selectively or replace with `package` module.   | `rev2-nginx-centos.yml`, `rev3-nginx-generic.yml` |
| Handlers                        | Trigger additional tasks when a change is made.                            | `rev5-handler.yml` |
| Service Check                   | Use `uri` module to validate HTTP status after nginx restart.              | `rev5-handler.yml` |
| Group Variables                 | Define OS-specific paths in `group_vars`.                                  | `group_vars/centos/nginx.yml` |
| Templating Website              | Use `template` module to render `index.html.j2` with variables.            | `rev6-template-site.yml` |
| Ansible Managed Metadata        | Use `ansible_managed` variable for audit/tracking.                         | `rev7-ansible-managed.yml` |
| Custom Logos via Vars File      | Add OS-specific branding using external variable files.                    | `rev8-vars-file.yml`, `vars/logos.yml` |
| Easter Egg with Game            | Use `unarchive` module to deploy a ZIP game + hyperlink in site.           | `rev9-unarchive-easteregg.yml` |

---

## 💡 Key Code Examples + Explanations

### ✅ Install EPEL (Extra Packages) on CentOS Only

```yaml
- name: Install EPEL
  yum:
    name: epel-release
    update_cache: yes
    state: latest
  when: ansible_distribution == "CentOS"
````

**Explanation**: This installs EPEL only on CentOS using a fact-based condition. It ensures we have extra packages like `nginx`.

---

### ✅ Install nginx Platform-Wise (Old vs New)

**Separate Tasks for CentOS and Ubuntu**:

```yaml
- name: Install nginx (CentOS)
  yum:
    name: nginx
    update_cache: yes
    state: present
  when: ansible_distribution == "CentOS"

- name: Install nginx (Ubuntu)
  apt:
    name: nginx
    update_cache: yes
    state: present
  when: ansible_distribution == "Ubuntu"
```

**Simplified using `package` module**:

```yaml
- name: Install nginx (Generic)
  package:
    name: nginx
    state: present
```

**Explanation**: `package` is OS-agnostic—it automatically selects the correct package manager (yum/apt).

---

### ✅ Restart nginx and Trigger Service Check

```yaml
- name: Restart nginx
  service:
    name: nginx
    state: restarted
  notify: check http service

handlers:
  - name: check http service
    uri:
      url: "http://{{ ansible_default_ipv4.address }}"
      status_code: 200
```

**Explanation**: Handler gets triggered only if `nginx` was restarted (i.e., changed state). It ensures the service is reachable post-deployment.

---

### ✅ Template Web Page with OS-Specific Path

```yaml
- name: Template index.html
  template:
    src: index.html.j2
    dest: "{{ nginx_root }}/index.html"
    mode: '0644'
```

In `group_vars/centos/nginx.yml`:

```yaml
nginx_root: /usr/share/nginx/html
```

In `group_vars/ubuntu/nginx.yml`:

```yaml
nginx_root: /var/www/html
```

**Explanation**: OS-specific root path is abstracted using group variables.

---

### ✅ Add Ansible Metadata in Template

In `ansible.cfg`:

```ini
ansible_managed = Managed by Ansible on host {{ inventory_hostname }} as {{ ansible_user_id }}
```

In `index.html.j2`:

```html
<p>{{ ansible_managed }}</p>
```

**Explanation**: Helps track when/where a file was created via Ansible. Useful for auditing.

---

### ✅ Deploy Easter Egg Game 🎮

```yaml
- name: Install unzip
  package:
    name: unzip
    state: present

- name: Deploy game
  unarchive:
    src: playbook_stacker.zip
    dest: "{{ nginx_root }}"
    remote_src: yes
    mode: '0755'
```

In Jinja2 Template:

```html
<a href="playbook_stacker/index.html"><img src="{{ logo }}" /></a>
```

**Explanation**: Clicking the logo now launches a hidden game bundled into your web app.

---

## 📘 Real-World Use Case

> I used this kind of setup in a DevSecOps project where we had to deploy an internal tool with different Linux flavors.
> To avoid redundant logic, I used `package`, `group_vars`, and templated messages for branding.
> Handlers ensured the app was running, and metadata helped trace config drift.

---

## 🎯 Interview Questions & Sample Answers

### Q1. How do you handle OS-specific installations in Ansible?

**A**:

* Use facts like `ansible_distribution` with `when` conditions to target `yum`, `dnf`, or `apt`.
* Alternatively, use the `package` module for abstraction.
* For paths/configs, use `group_vars` to define OS-specific variables.

---

### Q2. What are Ansible handlers? When did you use them?

**A**:
Handlers are special tasks triggered only when notified.
I used a handler to validate `nginx` service health using the `uri` module after restarting it—this avoids assuming success blindly and ensures automation reliability.

---

### Q3. How did you use templating to customize deployments?

**A**:
I used `template` module with `.j2` files to generate HTML files dynamically.
This allowed me to inject host-specific data, display logos based on OS, and insert metadata like `ansible_managed`.

---

### Q4. How do you verify if your web service is running post-deployment?

**A**:
I use the `uri` module inside a handler to perform an HTTP GET request.
If the return code is 200, the server is considered healthy.

---

### Q5. What is the use of `ansible_managed`?

**A**:
It’s a predefined variable that embeds metadata into a file like:

> “Managed by Ansible on host X as user Y.”

Helps track file origins and maintain control during audits.

---

## ✅ Summary

This project shows how to:

* Build OS-aware playbooks
* Use templates smartly
* Ensure services are functional
* Make automation fun (easter egg!)





# 📘 Ansible Playbooks: Creating and Executing

This section demonstrates foundational examples of writing, structuring, and running Ansible playbooks. Each example in this directory builds your understanding of how tasks are defined and executed across target machines using Ansible.


## 🗂️ Table of Contents

| Revision Folder | Description                                                |
| --------------- | ---------------------------------------------------------- |
| `01`            | Minimal playbook with single task using `ping`             |
| `02`            | Using `ansible-playbook` CLI with inventory and connection |
| `03`            | Adding debug task                                          |
| `04`            | Working with `gather_facts: false`                         |
| `05`            | Multiple tasks with `shell` and `command`                  |
| `06`            | Using `yum` and `apt` for package management               |
| `07`            | Using `when` conditionals                                  |
| `08`            | Registering variables and using `debug`                    |
| `09`            | Accessing host-specific facts via `hostvars`               |
| `10`            | Looping with `with_items`                                  |
| `11`            | Using `include_vars`                                       |
| `12`            | Applying group-specific variables using `group_vars`       |

---

## 🧪 01 — Basic Ping Playbook

```yaml
- hosts: all
  tasks:
    - name: Test connectivity
      ping:


### 🔍 Purpose

* Verifies Ansible connectivity across inventory nodes.

---

## 🧪 02 — CLI Execution Parameters

**Command:**

```bash
ansible-playbook playbook.yml -i inventory --user=ubuntu --ask-pass
```

### 🔍 Purpose

* Shows how to pass inventory and connection credentials via CLI.

---

## 🧪 03 — Debug Message

```yaml
- name: Display Hello Message
  debug:
    msg: "Hello from Ansible"
```

### 🔍 Purpose

* Introduces the `debug` module to output custom messages.

---

## 🧪 04 — Disabling Facts Gathering

```yaml
- hosts: all
  gather_facts: false
  tasks:
    - name: Just a test
      debug:
        msg: "Skipped gathering facts"
```

### 🔍 Purpose

* Improves speed when system facts are not required.

---

## 🧪 05 — Shell and Command Modules

```yaml
- name: Using command
  command: uptime

- name: Using shell
  shell: "echo $HOME"
```

### 🔍 Purpose

* Demonstrates difference between `command` (no shell features) and `shell` (full shell).

---

## 🧪 06 — Package Installation

```yaml
- name: Install Nginx on Ubuntu
  apt:
    name: nginx
    state: present
  when: ansible_distribution == "Ubuntu"

- name: Install Nginx on CentOS
  yum:
    name: nginx
    state: present
  when: ansible_distribution == "CentOS"
```

### 🔍 Purpose

* Platform-aware package management using conditionals.

---

## 🧪 07 — Conditional Execution with `when`

```yaml
- name: Only run this for Ubuntu
  debug:
    msg: "Running on Ubuntu"
  when: ansible_distribution == "Ubuntu"
```

---

## 🧪 08 — Register Variable

```yaml
- name: Get uptime
  command: uptime
  register: result

- name: Display output
  debug:
    var: result.stdout
```

### 🔍 Purpose

* Registers output of a task and uses it in subsequent ones.

---

## 🧪 09 — Accessing Hostvars

```yaml
- debug:
    msg: "{{ hostvars[inventory_hostname].ansible_port }}"
```

### 🧠 What’s Happening?

* `hostvars` is a magic variable containing facts for all hosts.
* `inventory_hostname` refers to the current host.
* You’re accessing a fact (`ansible_port`) stored for the host you’re currently running on.

---

## 🧪 10 — Loops

```yaml
- name: Install multiple packages
  apt:
    name: "{{ item }}"
    state: present
  with_items:
    - curl
    - vim
```

---

## 🧪 11 — Include Variables

```yaml
- include_vars: custom_vars.yml
```

### 🔍 Purpose

* Modularizes your variables into external files.

---

## 🧪 12 — Group Vars

Structure:

```
inventory/
├── group_vars/
│   └── webservers.yml
```

```yaml
# group_vars/webservers.yml
custom_message: "This is a webserver"
```

```yaml
- name: Display message
  debug:
    var: custom_message
```

### 🔍 Purpose

* Automatically loads variables for specific groups in your inventory.

---

## 💼 Real-World Usage

| Use Case                 | Description                                        |
| ------------------------ | -------------------------------------------------- |
| CI/CD Pipelines          | Automated provisioning of testing environments     |
| Multi-Platform Infra     | OS-aware task execution (`apt` vs `yum`)           |
| Inventory-Driven Actions | Use `group_vars` and `hostvars` for targeted tasks |
| Idempotent Infra         | Install packages, restart services only if needed  |

---

## 📜 Sample Interview Questions

1. **What is the difference between `shell` and `command` modules?**

   * `command` is safer and doesn’t use a shell.
   * `shell` is used when you need shell features like variables or pipes.

2. **How do you pass variables to your playbook from outside?**

   * Use `-e`, `include_vars`, or `group_vars`.

3. **What is `hostvars` used for?**

   * To access variables/facts from other hosts in the inventory.

4. **What’s the use of `gather_facts: false`?**

   * Skips collecting facts to speed up playbooks that don’t require them.

5. **How do you perform platform-specific tasks?**

   * Use `when` with `ansible_distribution`.

---

## 📦 GitHub Repo Reference

| Revision | Description                    | Link                                                                                                                                                                |
| -------- | ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 01–12    | Step-by-step playbook examples | [View on GitHub](https://github.com/ANSANJAY/diveintoansible/tree/master/Ansible%20Playbooks%2C%20Introduction/Ansible%20Playbooks%2C%20Creating%20and%20Executing) |

---


