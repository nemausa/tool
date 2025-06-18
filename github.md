Here’s your Git tips formatted in Markdown:

````markdown
# Git Configuration and Repository Cleanup

## 1. Store Credentials Permanently
By default, Git will write entered usernames and passwords to disk:
```bash
git config --global credential.helper store
````

---

## 2. Remove Files Larger Than 50 MB

1. Update package lists and install dependencies:

   ```bash
   sudo apt update
   sudo apt install git-lfs
   git lfs install
   sudo apt install -y python3-pip
   pip3 install --user git-filter-repo
   ```
2. Make sure `~/.local/bin` is in your PATH:

   ```bash
   export PATH=$PATH:$HOME/.local/bin
   ```
3. Strip out all blobs over 50 MB:

   ```bash
   git filter-repo --strip-blobs-bigger-than 50M --force
   ```

---

## 3. Keep Non-ASCII Filenames Readable

By default Git escapes non-ASCII filenames as `\uXXXX`. To disable this:

```bash
git config --system core.quotepath false
```

---

## 4. Use UTF-8 for Commit Messages & Logs

Ensure Git inputs/outputs use UTF-8:

```bash
git config --global i18n.commitEncoding utf-8
git config --global i18n.logOutputEncoding utf-8
```

---

## 5. Useful Git Queries

* **Search commits by author**

  ```bash
  git log --all --author="xxx"
  ```

* **Find branches containing a given commit**

  ```bash
  git branch --contains <commit-id>
  ```

```

Feel free to adjust any section as needed!
```
