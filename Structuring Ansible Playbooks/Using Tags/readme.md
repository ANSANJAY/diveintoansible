## ✅ Topic: Using Tags in Ansible

### 🔹 What Are Tags?

Tags are labels assigned to specific **tasks**, **plays**, or **imported files** in Ansible playbooks. They allow selective control over which parts of a playbook get executed.

---

### 🔹 Real-World Scenario

**Problem:** You’re managing a web server setup and want to:

* Install packages only once
* Avoid redeploying the app every time
* Restart services on demand

**Solution:** Use tags like `install`, `deploy`, `restart`, and run:

```bash
ansible-playbook webserver.yml --tags install
```

This skips deployment and restart — **saving time** during dev and test cycles.

---

### 🔹 Features of Tags

| Feature                 | Description                                                                      |
| ----------------------- | -------------------------------------------------------------------------------- |
| **Selective Execution** | Run only specific tagged tasks using `--tags`                                    |
| **Skip Logic**          | Use `--skip-tags` to avoid specific tasks                                        |
| **Play-level Tags**     | Assign tags to entire plays                                                      |
| **Special Tags**        | `always`, `tagged`, `untagged`, `all`                                            |
| **Tag Inheritance**     | Tags assigned to `import_tasks`, `include_tasks`, or `import_playbook` propagate |

---

### 🔹 Examples From GitHub Repo

📁 Repo: [Using Tags](https://github.com/ANSANJAY/diveintoansible/tree/master/Structuring%20Ansible%20Playbooks/Using%20Tags)

📄 `01-playbook.yml`

```yaml
- name: Install EPEL (for CentOS)
  yum:
    name: epel-release
    state: present
  when: ansible_os_family == "RedHat"
  tags: install-epel

- name: Install nginx
  package:
    name: nginx
    state: latest
  tags: install-nginx

- name: Restart nginx
  service:
    name: nginx
    state: restarted
  tags: restart-nginx

- name: Deploy app
  copy:
    src: index.html
    dest: /usr/share/nginx/html/index.html
  tags: deploy-app
```

📄 `04-playbook.yml` — Tag inheritance

```yaml
- name: Import common nginx setup
  import_playbook: nginx-common.yml
  tags:
    - nginx
```

---

### 🧪 Commands You Can Try

| Use Case                       | Command Example                                               |
| ------------------------------ | ------------------------------------------------------------- |
| Run only install tasks         | `ansible-playbook playbook.yml --tags install-nginx`          |
| Skip app deployment            | `ansible-playbook playbook.yml --skip-tags deploy-app`        |
| Run only tasks without tags    | `ansible-playbook playbook.yml --tags untagged`               |
| Run tasks tagged with `always` | Included by default (can skip with `--skip-tags always`)      |
| Assign tags to imported tasks  | Tags applied will **cascade down** to included/imported tasks |

---

### 🧠 Analogy

**Think of tags like Netflix filters.**
You don’t always want to watch the full list — just apply a filter like “Action” or “Comedy” and you see only what you want.

---

### 🎯 Interview Questions

**Q1: Why are tags useful in Ansible playbooks?**
**A:** They allow executing only specific tasks, improving speed and flexibility, especially in large or modular playbooks.

---

**Q2: What’s the difference between `--tags` and `--skip-tags`?**
**A:**

* `--tags`: Runs **only** the specified tags.
* `--skip-tags`: Runs **everything except** the specified tags.

---

**Q3: How does the `always` tag behave?**
**A:** Tasks with `always` run even when specific tags are used — unless skipped explicitly using `--skip-tags always`.

---

**Q4: What happens when you apply a tag to an imported playbook or task file?**
**A:** The tag is **inherited** by all tasks within that file.

---

**Q5: Can play-level tags interfere with `gather_facts`?**
**A:** Yes. Adding a tag to the entire play removes the `always` tag from `gather_facts`, so it may be skipped. You can work around this by creating a **pre-play** without tags to gather facts first.

