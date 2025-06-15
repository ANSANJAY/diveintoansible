
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
