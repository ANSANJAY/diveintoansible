# ✅ Ansible Notes: Using Roles

---

### 1. **Topic Overview**

**What are Roles in Ansible?**

* Roles help organize playbooks into reusable components.
* They are a directory structure with subfolders for tasks, vars, handlers, templates, files, etc.
* Promotes **modularity**, **cleaner organization**, and **reusability**.
* Used when your playbook becomes large and you want separation of concerns.

**Core Features:**

* Encapsulates logic into a self-contained folder.
* Supports dependencies, default variables, and shared templates.
* Can be easily shared via **Ansible Galaxy**.

---

### 2. **Real-World Usage**

| Use Case                             | Why Roles Help                                        | Real-World Integration                          |
| ------------------------------------ | ----------------------------------------------------- | ----------------------------------------------- |
| Web server setup (e.g., NGINX)       | Break into `nginx` and `webapp` roles                 | Infra as Code (IaC) for provisioning web layers |
| CI/CD pipelines                      | Share roles for build/deploy routines                 | Reusable Jenkins/GitHub Actions steps           |
| Multi-OS environment (Ubuntu/CentOS) | Parameterize logic using `ansible_distribution`       | Ensure portability in hybrid cloud environments |
| Security patching                    | Create a `patching` role with idempotent update logic | Scheduled compliance via Ansible Tower          |
| Infrastructure abstraction           | Reduce duplicate tasks across teams/projects          | Maintain consistency across DevOps teams        |

---

### 3. **Code Examples**

📁 GitHub Repo:
[ANSANJAY/diveintoansible – Using Roles](https://github.com/ANSANJAY/diveintoansible/tree/master/Structuring%20Ansible%20Playbooks/Using%20Roles)

#### ✅ Initialize a Role

```bash
ansible-galaxy init nginx
```

#### ✅ Sample Directory Tree

```
roles/
└── nginx/
    ├── tasks/main.yml
    ├── handlers/main.yml
    ├── templates/index.html.j2
    ├── files/logo.png
    ├── vars/main.yml
    ├── defaults/main.yml
    ├── meta/main.yml
```

#### ✅ Example `site.yml` playbook

```yaml
- name: Setup Web Environment
  hosts: all
  become: yes
  roles:
    - nginx
    - role: webapp
      vars:
        target_dir: "{{ ansible_distribution == 'CentOS' | ternary('/usr/share/nginx/html', '/var/www/html') }}"
```

#### ✅ Role Dependency (`webapp/meta/main.yml`)

```yaml
dependencies:
  - role: nginx
```

#### ✅ Run the Playbook

```bash
ansible-playbook site.yml
```

---

### 4. **Interview Questions + Sample Answers**

**Q1: What are Ansible roles and why are they used?**
**A:** Roles are self-contained folders in Ansible that organize related playbook content (tasks, vars, handlers). They're used for reusability and maintainability, especially in large projects.

---

**Q2: How do you create a role in Ansible?**
**A:** Use `ansible-galaxy init <role-name>` to generate the role skeleton. Then populate folders like `tasks`, `handlers`, `templates`, etc.

---

**Q3: How do you pass parameters to roles dynamically?**
**A:** Use the dictionary format:

```yaml
roles:
  - role: webapp
    target_dir: "{{ custom_path }}"
```

---

**Q4: Can a role depend on another role?**
**A:** Yes. Define dependencies in `meta/main.yml` under the `dependencies` key. The dependent role will execute automatically.

---

**Q5: Where should you place Jinja templates or custom vars in a role?**
**A:**

* Templates → `templates/`
* Custom vars → `vars/main.yml`
* Default vars → `defaults/main.yml`

---

### 5. **Analogy to Remember**

> **"Think of roles like a kitchen cabinet.** Each shelf (tasks, vars, templates) stores a specific item. You don’t dump everything on one shelf (playbook); instead, roles keep things modular and easy to find.”

---

### 6. **GitHub Repo Reference**

| Revision Folder | What It Demonstrates                              | Link                                                                                                                      |
| --------------- | ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| `revision-01`   | Manual playbook before roles                      | [🔗](https://github.com/ANSANJAY/diveintoansible/tree/master/Structuring%20Ansible%20Playbooks/Using%20Roles/revision-01) |
| `revision-03`   | Fully functional nginx role                       | [🔗](https://github.com/ANSANJAY/diveintoansible/tree/master/Structuring%20Ansible%20Playbooks/Using%20Roles/revision-03) |
| `revision-05`   | Split into nginx and webapp roles                 | [🔗](https://github.com/ANSANJAY/diveintoansible/tree/master/Structuring%20Ansible%20Playbooks/Using%20Roles/revision-05) |
| `revision-07`   | Role parameterization with `ansible_distribution` | [🔗](https://github.com/ANSANJAY/diveintoansible/tree/master/Structuring%20Ansible%20Playbooks/Using%20Roles/revision-07) |
| `revision-08`   | Role dependencies in `meta/main.yml`              | [🔗](https://github.com/ANSANJAY/diveintoansible/tree/master/Structuring%20Ansible%20Playbooks/Using%20Roles/revision-08) |

---

