

### 🧠 Ansible Playbooks: Facts —  Notes

---

### ✅ Concept (Simple Explanation)

| Concept                   | Explanation                                                                                    | Example                                                                               |
| ------------------------- | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| **Facts**                 | Facts are pieces of information (variables) that Ansible automatically collects about a host.  | Hostname, IP, OS type, RAM, CPU cores                                                 |
| **Setup Module**          | Module used to gather system facts. Runs automatically by default when `gather_facts: true`.   | `ansible all -m setup`                                                                |
| **Gather Subset**         | Restrict which facts are collected to reduce noise.                                            | `gather_subset=network`                                                               |
| **Filter**                | Collect only specific facts using wildcard or exact name.                                      | `ansible all -m setup -a "filter=ansible_mem*"`                                       |
| **Accessing Facts**       | Facts are available as variables during playbook execution.                                    | `ansible_default_ipv4.address`                                                        |
| **Custom Facts**          | User-defined scripts (JSON or INI) that return system info. Stored in `/etc/ansible/facts.d/`. | Script to return custom app version or build date                                     |
| **Non-root Custom Facts** | You can use `fact_path` to collect facts from user-owned directories (non-root environments).  | Store facts in `/home/ansible/facts.d` and call with `setup` module using `fact_path` |

---

### ✅ Real-World Usage Examples from Your Repo

#### 📁 Revision 01: Gather Specific Facts Using Subset

```bash
ansible centos1 -m setup -a "gather_subset=network"
```

* Retrieves only networking-related facts.
* Useful when you want IP, MAC address, interface names only.

---

#### 📁 Revision 02: Define Custom Facts (JSON + INI)

**templates/getdate1.sh**

```bash
#!/bin/bash
echo '{"date": "2025-06-14"}'
```

**templates/getdate2.ini**

```ini
[getdate2]
date = 2025-06-14
```

* `getdate1.sh` uses JSON format.
* `getdate2.ini` requires a category (`[getdate2]`) for INI to work.
* These are placed in `/etc/ansible/facts.d/`.

---

#### 📁 Revision 03: Use Custom Facts in a Playbook

```yaml
- name: Show custom facts
  debug:
    msg: "Date1: {{ ansible_local.getdate1.date }} | Date2: {{ ansible_local.getdate2.date }}"
```

---

#### 📁 Revision 05: Deploy Custom Facts Across Hosts

```yaml
- name: Create facts directory on remote hosts
  file:
    path: /etc/ansible/facts.d
    state: directory
    mode: '0755'

- name: Copy custom facts
  copy:
    src: "{{ item }}"
    dest: /etc/ansible/facts.d/
    mode: '0755'
  loop:
    - getdate1.sh
    - getdate2.ini

- name: Refresh facts
  ansible.builtin.setup:
```

---

#### 📁 Revision 06: Custom Facts Without Root

```yaml
- name: Create local facts dir in user home
  file:
    path: /home/ansible/facts.d
    state: directory
    mode: '0755'

- name: Run setup using fact_path
  ansible.builtin.setup:
    fact_path: /home/ansible/facts.d
```

---

### 🧠 Interview Q\&A (Facts in Ansible)

#### ❓ Q1: What are Ansible Facts?

**Answer:**
Facts are system information collected by Ansible using the `setup` module. These include network settings, OS details, memory, CPU info, etc. They're accessible as variables and help customize playbooks dynamically based on the host.

---

#### ❓ Q2: What is the `setup` module and when is it used?

**Answer:**
The `setup` module is responsible for collecting facts. It runs automatically at the beginning of a playbook (if `gather_facts: true`). You can also call it explicitly to refresh facts or specify what to collect using filters or subsets.

---

#### ❓ Q3: How do you reduce the output from the `setup` module?

**Answer:**
You can use:

* `gather_subset` (e.g., `gather_subset=network`)
* Exclude default collections with `!all`, `!min`
* Use `filter=` to target specific facts (e.g., `filter=ansible_mem*`)

---

#### ❓ Q4: What are custom facts, and when would you use them?

**Answer:**
Custom facts are user-defined scripts (JSON or INI format) that return structured data. They're useful when the default facts don’t provide required info — for example, application build versions or local business-specific metadata.

---

#### ❓ Q5: Can you use custom facts without root access?

**Answer:**
Yes. You can define a `fact_path` parameter in the `setup` module to point to a directory like `/home/ansible/facts.d`, enabling fact collection in non-root environments.

---

