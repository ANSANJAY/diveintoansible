
# 🧾 Ansible Inventory Revisions – Code & Explanation

This document provides a revision-by-revision breakdown of inventory examples from the [Inventories](https://github.com/ANSANJAY/diveintoansible/tree/master/Ansible%20Architecture%20and%20Design/Inventories) section of the "Ansible Architecture and Design" course.

---

## ✅ Revision 01: Basic INI Format with One Host

```ini
[all]
centos1
```

📘 **Explanation**:  
A simple inventory where `centos1` is part of the default `all` group. Every host is automatically part of `all`.

---

## ✅ Revision 02: Disabling Host Key Checking

```ini
[defaults]
inventory=hosts
host_key_checking=False
```

📘 **Explanation**:  
Added `host_key_checking=False` in `ansible.cfg` to avoid manual SSH fingerprint confirmation during automation.

---

## ✅ Revision 03: Multiple Groups – CentOS and Ubuntu

```ini
[centos]
centos1
centos2
centos3

[ubuntu]
ubuntu1
ubuntu2
ubuntu3
```

📘 **Explanation**:  
Created two groups and organized hosts accordingly for targeted automation.

---

## ✅ Revision 04: Using Host Variables (User Per Host)

```ini
[centos]
centos1 ansible_user=root
centos2 ansible_user=root
centos3 ansible_user=root

[ubuntu]
ubuntu1
ubuntu2
ubuntu3
```

📘 **Explanation**:  
Set `ansible_user=root` for each CentOS host, allowing SSH as root.

---

## ✅ Revision 05: Ubuntu Hosts with `become`

```ini
[ubuntu]
ubuntu1 ansible_user=ansible ansible_become=true ansible_become_pass=password
ubuntu2 ansible_user=ansible ansible_become=true ansible_become_pass=password
ubuntu3 ansible_user=ansible ansible_become=true ansible_become_pass=password
```

📘 **Explanation**:  
Connect to Ubuntu as `ansible` user and elevate privileges using `sudo`.

---

## ✅ Revision 06: Custom SSH Port for Host

```ini
[centos]
centos1 ansible_port=2222
centos2
centos3
```

📘 **Explanation**:  
`centos1` listens on a non-standard SSH port (2222). Others default to port 22.

---

## ✅ Revision 07: SSH Port as Part of Hostname

```ini
[centos]
centos1:2222
centos2
centos3
```

📘 **Explanation**:  
Alternate syntax for specifying port inline: `hostname:port`.

---

## ✅ Revision 08: Localhost Connection

```ini
[control]
ubuntuC ansible_connection=local
```

📘 **Explanation**:  
Run tasks locally on `ubuntuC`, no SSH needed.

---

## ✅ Revision 09: Using Ranges

```ini
[centos]
centos1 ansible_port=2222
centos[2:3]

[ubuntu]
ubuntu[1:3]
```

📘 **Explanation**:  
Simplifies inventory using host range syntax. `centos1` remains explicitly defined.

---

## ✅ Revision 10: Group Variables

```ini
[centos]
centos1
centos2
centos3

[centos:vars]
ansible_user=root

[ubuntu]
ubuntu1
ubuntu2
ubuntu3

[ubuntu:vars]
ansible_user=ansible
ansible_become=true
ansible_become_pass=password
```

📘 **Explanation**:  
Variables now defined at group level to avoid repetition.

---

## ✅ Revision 11: Children Groups

```ini
[linux:children]
centos
ubuntu
```

📘 **Explanation**:  
Create a parent group `linux` to run playbooks across both `centos` and `ubuntu`.

---

## ✅ Revision 12: All Group Vars and Precedence

```ini
[all:vars]
ansible_port=1234
```

📘 **Explanation**:  
All hosts will try to use port 1234 unless a host-specific `ansible_port` overrides it.

---

## ✅ Revision 13: Group Vars for Parent Group

```ini
[linux:vars]
ansible_user=devops
```

📘 **Explanation**:  
Apply variables to the `linux` parent group. Still overridden by host or child group vars.

---

## ✅ Revision 14: Inventory in YAML

```yaml
---
centos:
  hosts:
    centos1:
      ansible_port: 2222
    centos2:
    centos3:
  vars:
    ansible_user: root

ubuntu:
  hosts:
    ubuntu1:
    ubuntu2:
    ubuntu3:
  vars:
    ansible_user: ansible
    ansible_become: true
    ansible_become_pass: password

linux:
  children:
    centos:
    ubuntu:
...
```

📘 **Explanation**:  
Same inventory structure expressed in YAML format. Clean and readable.

---

## ✅ Revision 15: Inventory in JSON

```json
{
  "centos": {
    "hosts": {
      "centos1": { "ansible_port": 2222 },
      "centos2": null,
      "centos3": null
    },
    "vars": {
      "ansible_user": "root"
    }
  },
  "ubuntu": {
    "hosts": {
      "ubuntu1": null,
      "ubuntu2": null,
      "ubuntu3": null
    },
    "vars": {
      "ansible_user": "ansible",
      "ansible_become": true,
      "ansible_become_pass": "password"
    }
  },
  "linux": {
    "children": ["centos", "ubuntu"]
  }
}
```
Here are your structured **technical notes** for the **Ansible Modules** video, with clear breakdowns, examples, and interview prep:

---

## 🧩 Topic: **Ansible Modules**

### 1. ✅ **Simple Explanation**

Ansible modules are like tools in a toolbox—each module performs a specific function, such as creating a file, copying files, installing packages, or gathering system info.

Ansible includes hundreds of built-in modules (it's a "batteries-included" framework), and you can use them in ad-hoc commands or in playbooks.

---

### 2. ✅ **Modules Covered with Examples & Notes**

| **Module**      | **What It Does**                             | **Example Usage**                                                | **Notes**                                                    |
| --------------- | -------------------------------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------ |
| **setup**       | Gathers system facts (OS, IP, RAM, etc.)     | `ansible centos1 -m setup`                                       | Run automatically in playbooks unless disabled               |
| **file**        | Creates files, directories, sets permissions | `ansible all -m file -a "path=/tmp/test state=touch"`            | Used for setting state (file, dir, absent, etc.)             |
| **copy**        | Copies files from control node to remote     | `ansible all -m copy -a "src=testfile dest=/tmp/testfile"`       | Uses checksums for idempotence                               |
| **command**     | Runs commands on remote nodes                | `ansible all -a "hostname"`                                      | Doesn’t support pipes, redirection, or env vars like `$HOME` |
| **shell**       | Like command, but supports shell features    | `ansible all -m shell -a "echo $HOME"`                           | Use when shell syntax is needed                              |
| **fetch**       | Pulls a file from remote to control node     | `ansible all -m fetch -a "src=/tmp/test.txt dest=./tmp flat=no"` | Creates a directory per host                                 |
| **ansible-doc** | Shows module documentation                   | `ansible-doc file`                                               | View all options, params, examples                           |

---

### 🔁 Idempotence Explained:

Ansible is **idempotent**—it only makes changes if necessary.
For example:

* First run: sets mode of `/tmp/testfile` to `0600` → **Yellow** (changed)
* Second run: nothing to change → **Green** (success, no change)

This ensures you can rerun playbooks safely multiple times without unintended side effects.

---

### ⚡ Output Color Codes:

| Color     | Meaning                 |
| --------- | ----------------------- |
| 🔴 Red    | Failure                 |
| 🟡 Yellow | Success with changes    |
| 🟢 Green  | Success without changes |

---

### 🛠️ Real-World Usage:

* I’ve used the **setup** module to gather system facts and dynamically apply OS-specific roles.
* I used **file** and **copy** modules to deploy and secure configuration files with correct permissions across 100+ Linux nodes.
* The **command** module helped me run quick diagnostics like `hostname` or `uptime`.
* I used **fetch** in compliance audits to collect log files and system state from all nodes to a central location for inspection.
* For CI pipelines, **ansible-doc** became my go-to for quickly checking parameters for modules I was unfamiliar with.

---

### 🧠 Interview Questions:

**Beginner:**

* What are Ansible modules?
* How is the `command` module different from the `shell` module?

**Intermediate:**

* What is idempotence in Ansible and how do modules support it?
* What does the `fetch` module do and where is it useful?

**Advanced:**

* What is the difference between `ansible.builtin.file` and using shell commands like `touch`?
* How do modules determine whether a task results in "changed" or "ok"?

---

