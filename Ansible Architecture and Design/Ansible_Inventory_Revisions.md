
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


# 🧾 Ansible Modules – Notes & Examples

This document provides detailed notes and practical examples from the **Modules** section of the *Ansible Architecture and Design* course.

---

## ✅ Overview

Ansible includes a variety of built-in modules to automate tasks like file management, command execution, and system information gathering. These modules are idempotent, meaning they only make changes when needed.

---

## 📦 Common Modules with Examples

### 🔹 1. `setup` – Gather Facts

```bash
ansible centos1 -m setup
```

🔍 **Explanation**:  
Gathers system info (facts) like IP, OS, architecture. This module runs automatically in playbooks unless disabled.

---

### 🔹 2. `file` – Create or Modify File Attributes

#### Create a zero-length file (like `touch`):

```bash
ansible all -m file -a "path=/tmp/testfile state=touch"
```

#### Set file permissions to 600:

```bash
ansible all -m file -a "path=/tmp/testfile state=file mode=0600"
```

🔍 **Explanation**:  
- `state=touch`: creates/updates timestamp like `touch`
- `state=file`: ensures it is a regular file
- `mode=0600`: sets file permissions (rw-------)

---

### 🔹 3. `copy` – Copy Files to Remote Hosts

#### Copy a local file to all hosts:

```bash
ansible all -m copy -a "src=./testfile dest=/tmp/testfile"
```

#### Copy file from remote source (host to host copy):

```bash
ansible all -m copy -a "src=/etc/hosts dest=/tmp/hosts_backup remote_src=yes"
```

🔍 **Explanation**:  
- Uses checksum to check for changes.
- Remote source must exist on the managed host.

---

### 🔹 4. `command` – Run Simple Commands

#### Run hostname:

```bash
ansible all -a "hostname" -o
```

#### Run only if a file does not exist (`creates`):

```bash
ansible all -m command -a "touch /tmp/marker creates=/tmp/marker"
```

#### Run only if a file **does** exist (`removes`):

```bash
ansible all -m command -a "rm /tmp/marker removes=/tmp/marker"
```

🔍 **Explanation**:  
- `creates=` → skips if file exists.
- `removes=` → skips if file doesn't exist.

---

### 🔹 5. `shell` – Use Shell Syntax

```bash
ansible all -m shell -a "echo $HOME > /tmp/homedir.txt"
```

🔍 **Explanation**:  
Use `shell` instead of `command` when you need environment variables or redirection (`>`, `|`).

---

### 🔹 6. `fetch` – Pull File from Remote to Local

#### Step 1: Create file on remote host:

```bash
ansible all -m file -a "path=/tmp/test_modules.txt state=touch mode=0600"
```

#### Step 2: Fetch it locally:

```bash
ansible all -m fetch -a "src=/tmp/test_modules.txt dest=./tmp flat=no"
```

🔍 **Explanation**:  
Creates folder structure like `tmp/<hostname>/tmp/test_modules.txt` on the control node.

---

### 🔹 7. `ansible-doc` – View Module Documentation

```bash
ansible-doc file
ansible-doc fetch
```

🔍 **Explanation**:  
Shows description, parameters, return values, examples. Great for local offline help.

---

## 🧠 Idempotence in Action

- Run file creation → 🟡 Yellow (Changed)
- Run again → 🟢 Green (No change)
- Change manually → Run again → 🟡 Yellow (Fixed)

Ansible ensures the system matches the **desired state**, regardless of its **current state**.

---

## 🎨 Output Colors

| Color | Meaning |
|-------|---------|
| 🟢 Green | Success, no change |
| 🟡 Yellow | Success, with change |
| 🔴 Red | Failure |

---

## 🧠 Interview Questions

- What is the difference between `command` and `shell` modules?
- How does Ansible ensure idempotence?
- When would you use `remote_src=yes` in the copy module?
- What does the `creates` or `removes` option do in the command module?
- How does `fetch` differ from `copy`?

---

Ready to play with modules in playbooks? → Proceed to the next section: **Ansible Playbooks**
