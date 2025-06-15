# 📘 Ansible Playbooks: Breakdown of Sections

This guide explains the structure and behavior of Ansible playbooks, aligned with the example revisions in this folder. Each revision introduces a new concept, with hands-on YAML examples and explanations.

---

## ✅ Revision 01 – Skeleton Playbook with Comments

```yaml
---
- name: Example MOTD Playbook
  hosts: centos
  vars:
    motd: "This is the CentOS MOTD"
  tasks:
    # Tasks will go here
  handlers:
    # Handlers will go here
````

📘 **Explanation**:
Outlines the major sections: `hosts`, `vars`, `tasks`, and `handlers`. Each playbook is a list of "plays."

---

## ✅ Revision 02 – First Working Playbook with Copy Module

```yaml
---
- name: Update MOTD on CentOS
  hosts: centos
  become: true
  tasks:
    - name: Copy MOTD File
      copy:
        src: centos_motd
        dest: /etc/motd
```

📘 **Explanation**:
Uses the `copy` module to push a file to CentOS nodes. Fact gathering (setup) runs automatically.

---

## ✅ Revision 03 – Disabling Fact Gathering

```yaml
---
- name: Update MOTD (No Facts)
  hosts: centos
  gather_facts: false
  become: true
  tasks:
    - name: Copy MOTD File
      copy:
        src: centos_motd
        dest: /etc/motd
```

📘 **Explanation**:
Disabling `gather_facts` reduces playbook runtime when facts are not needed.

---

## ✅ Revision 04 – Using `content` Instead of `src`

```yaml
---
- name: MOTD with Inline Content
  hosts: centos
  become: true
  tasks:
    - name: Create MOTD File
      copy:
        content: "Welcome to CentOS!"
        dest: /etc/motd
```

📘 **Explanation**:
No external file required. `content` directly embeds text.

---

## ✅ Revision 05 – Using Variables in Content

```yaml
---
- name: MOTD via Variable
  hosts: centos
  become: true
  vars:
    motd: "Welcome to CentOS!\\n"
  tasks:
    - name: Create MOTD File
      copy:
        content: "{{ motd }}"
        dest: /etc/motd
```

📘 **Explanation**:
Defines `motd` as a play-level variable. Uses Jinja2 syntax `{{ }}` to reference it.

🔧 **CLI Override Example**:

```bash
ansible-playbook playbook.yml -e "motd='Overridden MOTD\\n'"
```

---

## ✅ Revision 06 – Introducing Handlers

```yaml
---
- name: MOTD with Handler
  hosts: centos
  become: true
  vars:
    motd: "Welcome with handler\\n"
  tasks:
    - name: Copy MOTD
      copy:
        content: "{{ motd }}"
        dest: /etc/motd
      notify: Show MOTD Change

  handlers:
    - name: Show MOTD Change
      debug:
        msg: "MOTD has been updated"
```

📘 **Explanation**:
The handler is triggered only if the `copy` task results in a change.

---

## ✅ Revision 07 – Conditional Tasks using `when`

```yaml
---
- name: Conditional MOTD per OS
  hosts: linux
  become: true
  gather_facts: true
  vars:
    centos_motd: "This is CentOS MOTD\\n"
    ubuntu_motd: "This is Ubuntu MOTD\\n"
  tasks:
    - name: Set MOTD for CentOS
      copy:
        content: "{{ centos_motd }}"
        dest: /etc/motd
      when: ansible_distribution == "CentOS"

    - name: Set MOTD for Ubuntu
      copy:
        content: "{{ ubuntu_motd }}"
        dest: /etc/motd
      when: ansible_distribution == "Ubuntu"
```

📘 **Explanation**:
Leverages system facts (e.g., `ansible_distribution`) to apply OS-specific logic.

---

## ✅ Challenge Task – Dynamic MOTD for Ubuntu

```yaml
---
- name: Dynamic Ubuntu MOTD
  hosts: ubuntu
  become: true
  tasks:
    - name: Copy dynamic MOTD script
      copy:
        src: 60-ansible-motd
        dest: /etc/update-motd.d/60-ansible-motd
        mode: preserve
      notify: MOTD Script Installed

  handlers:
    - name: MOTD Script Installed
      debug:
        msg: "Dynamic MOTD installed"
```

📘 **Explanation**:
Copies an executable script to Ubuntu’s dynamic MOTD directory. The script displays time-based messages like “At the third stroke...”.

---

## ✅ Bonus – Clean-Up with Ansible

```bash
ansible ubuntu -m file -a "path=/etc/update-motd.d/60-ansible-motd state=absent" -o
```

📘 **Explanation**:
Removes the custom MOTD script cleanly from all Ubuntu hosts.

---

## 📚 Key Concepts Recap

| Concept        | Purpose                            |
| -------------- | ---------------------------------- |
| `hosts`        | Define play target(s)              |
| `gather_facts` | Use or skip setup module           |
| `vars`         | Declare play-specific variables    |
| `copy`         | Transfer file or content to remote |
| `content`      | Inline file content in `copy`      |
| `handlers`     | Trigger tasks only on change       |
| `notify`       | Notify a handler                   |
| `when`         | Conditional execution              |
| `extra-vars`   | Override variables via CLI         |

---

## 🧠 Interview Questions

* What are the sections of a typical playbook?
* How do handlers work in Ansible?
* What is the difference between `src` and `content` in the `copy` module?
* How do you target specific OS types using `when`?
* What’s the benefit of skipping fact gathering?

---

