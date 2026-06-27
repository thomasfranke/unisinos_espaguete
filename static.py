import os, re, csv

PROJECT_PACKAGE = "flutter_spaghetti"
IGNORED_PACKAGES = {"flutter"}

rows = []
for dirpath, _, files in os.walk("lib"):
    for f in files:
        if not f.endswith(".dart"):
            continue
        path = os.path.join(dirpath, f)
        with open(path, encoding="utf-8") as fh:
            content = fh.read()
        imports = re.findall(r"^import\s+['\"]package:([^/'\"]+)", content, re.MULTILINE)
        external = [pkg for pkg in imports if pkg != PROJECT_PACKAGE and pkg not in IGNORED_PACKAGES]
        rows.append({
            "file": path,
            "total_imports": len(imports),
            "external_imports": len(external),
            "external_packages": external,
        })

with open("imports_report.csv", "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=["file", "total_imports", "external_imports", "external_packages"])
    writer.writeheader()
    writer.writerows(rows)

# --- Resumo no console ---
total_files = len(rows)
total_ext = sum(r["external_imports"] for r in rows)
avg_ext = total_ext / total_files if total_files else 0

print(f"Arquivos analisados: {total_files}")
print(f"Total de imports externos: {total_ext}")
print(f"Média de imports externos por arquivo: {avg_ext:.2f}")
print()
print(f"{'ext':>3}  arquivo")
for row in sorted(rows, key=lambda r: r["external_imports"], reverse=True):
    print(f"{row['external_imports']:>3}  {row['file']}  {row['external_packages']}")

print()
print(f"{'TOTAL':>3}  {total_ext}")