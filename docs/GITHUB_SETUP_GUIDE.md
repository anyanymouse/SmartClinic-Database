# 📚 GitHub Setup Guide - Smart Clinic Database

دليل شامل لرفع مشروع Smart Clinic Database على GitHub

---

## **الخطوة 1️⃣: إنشاء حساب GitHub (إذا لم يكن لديك)**

### خطوات إنشاء الحساب:
1. اذهب إلى: https://github.com
2. اضغط على **"Sign up"**
3. أدخل:
   - البريد الإلكتروني
   - اسم المستخدم
   - كلمة المرور
4. اضغط **"Create account"**
5. تحقق من بريدك الإلكتروني

---

## **الخطوة 2️⃣: إنشاء مستودع جديد على GitHub**

### خطوات الإنشاء:

1. **تسجيل الدخول** إلى GitHub
2. اضغط على **"+"** في الزاوية العلوية اليمنى
3. اختر **"New repository"**
4. **ملأ المعلومات:**

```
Repository name: SmartClinic-Database
Description: Smart Clinic Database System - IT403 Project
                (Clinic appointment, patient, treatment management)

Visibility: PUBLIC ✅ (يجب أن يكون عام لأن الأستاذ سيرى المشروع)

Initialize this repository with:
- ☐ Add a README file (سنضيفه بنفسنا)
- ☐ Add .gitignore (سنضيفه بنفسنا)
- ☐ Choose a license (اختياري)
```

5. اضغط **"Create repository"**

### **ستحصل على رابط مثل:**
```
https://github.com/YOUR_USERNAME/SmartClinic-Database.git
```

احفظ هذا الرابط! 📌

---

## **الخطوة 3️⃣: تثبيت Git على حاسوبك**

### **Windows:**
1. اذهب إلى: https://git-scm.com/download/win
2. حمّل الملف وثبّته
3. افتح **Git Bash** (ستظهر في قائمة ابدأ)

### **Mac:**
```bash
brew install git
```

### **Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install git
```

### **التحقق من التثبيت:**
```bash
git --version
```

---

## **الخطوة 4️⃣: تكوين Git (المرة الأولى فقط)**

افتح **Git Bash** أو **Terminal** وأدخل:

```bash
# استبدل بأسماء حقيقية
git config --global user.name "Your Full Name"
git config --global user.email "your.email@example.com"

# تحقق من التكوين
git config --global --list
```

**مثال:**
```bash
git config --global user.name "Hanadi Abdullah Alshehri"
git config --global user.email "hanadi.alshehri@university.edu"
```

---

## **الخطوة 5️⃣: نسخ المستودع (Clone)**

### **إنشاء مجلد للمشروع:**

1. **Windows:**
   ```bash
   # اختر المسار الذي تريده (مثلاً سطح المكتب)
   cd Desktop
   ```

2. **Mac/Linux:**
   ```bash
   cd ~/Documents
   ```

### **نسخ المستودع:**

```bash
# استبدل YOUR_USERNAME و SmartClinic-Database بـ أسماءك الفعلية
git clone https://github.com/YOUR_USERNAME/SmartClinic-Database.git

# الدخول إلى المجلد
cd SmartClinic-Database
```

**ستكون النتيجة:**
```
SmartClinic-Database/
└── .git/ (مجلد مخفي)
```

---

## **الخطوة 6️⃣: تنظيم ملفات المشروع**

### **أنشئ هيكل المشروع التالي:**

```bash
# داخل مجلد SmartClinic-Database

# إنشاء المجلدات
mkdir database
mkdir documentation
mkdir screenshots
mkdir queries

# انسخ الملفات:
# 1. انسخ SmartClinic.sql إلى مجلد database/
# 2. انسخ التقارير إلى مجلد documentation/
# 3. انسخ الصور إلى مجلد screenshots/
# 4. انسخ ملفات الاستعلامات إلى مجلد queries/
```

### **النتيجة النهائية:**
```
SmartClinic-Database/
│
├── README.md
├── .gitignore
├── GITHUB_SETUP_GUIDE.md
│
├── database/
│   └── SmartClinic.sql
│
├── documentation/
│   ├── Project_Report.pdf
│   ├── Project_Report.docx
│   └── Mid-Project_Report.pdf
│
├── screenshots/
│   ├── database-tables/
│   │   ├── table-employee.png
│   │   ├── table-patient.png
│   │   └── ...
│   ├── queries-results/
│   │   └── ...
│   └── er-diagram/
│       └── ER-diagram.png
│
└── queries/
    ├── select-queries.sql
    ├── join-queries.sql
    ├── nested-queries.sql
    ├── aggregate-queries.sql
    ├── update-delete.sql
    ├── view-creation.sql
    └── trigger-creation.sql
```

---

## **الخطوة 7️⃣: إضافة الملفات و Commit الأول**

### **1. عرض حالة المشروع:**
```bash
git status
```

**ستظهر:**
```
Untracked files:
  README.md
  .gitignore
  database/
  documentation/
  ...
```

### **2. إضافة جميع الملفات:**
```bash
git add .
```

### **3. التحقق:**
```bash
git status
```

**ستظهر:**
```
Changes to be committed:
  new file: README.md
  new file: .gitignore
  ...
```

### **4. Commit الأول:**
```bash
git commit -m "Initial project setup: Database structure and documentation"
```

### **5. رفع إلى GitHub:**
```bash
git push origin main
```

**ستطلب منك كلمة المرور أو الـ Token (في الخطوة 8)**

---

## **الخطوة 8️⃣: إعداد الـ Token (للمرة الأولى)**

إذا طلب منك GitHub كلمة مرور:

1. اذهب إلى: https://github.com/settings/tokens
2. اضغط **"Generate new token"**
3. اختر **"Generate new token (classic)"**
4. **ملأ المعلومات:**
   ```
   Token name: git-cli
   Expiration: 90 days (أو أكثر)
   Select scopes:
   ☑ repo (Full control of private repositories)
   ☑ workflow
   ```
5. اضغط **"Generate token"**
6. **انسخ الـ Token** (لن تراه مرة أخرى!)
7. الصقه عند طلب كلمة المرور في Git Bash

---

## **الخطوة 9️⃣: Commits منتظمة (مهمة جداً!)**

### **بعد كل مرحلة من المشروع، قم بـ Commit:**

```bash
# 1. بعد إنشاء الجداول
git add .
git commit -m "Database implementation: Create all tables with constraints"
git push origin main

# 2. بعد إدراج البيانات
git add .
git commit -m "Data insertion: Add 5+ records to each table"
git push origin main

# 3. بعد كتابة الاستعلامات
git add .
git commit -m "SQL operations: Add SELECT, JOIN, and nested queries"
git push origin main

# 4. بعد إنشاء VIEW و TRIGGER
git add .
git commit -m "Advanced SQL: Create views and triggers"
git push origin main

# 5. بعد إضافة التقارير والصور
git add .
git commit -m "Documentation: Add project report and screenshots"
git push origin main

# 6. Commit النهائي
git add .
git commit -m "Final submission: Complete project with all deliverables"
git push origin main
```

### **نصائح لـ Commit Messages:**
✅ **جيدة:**
```
"Add database tables with primary and foreign keys"
"Implement SELECT queries for patient management"
"Update README with setup instructions"
```

❌ **سيئة:**
```
"update"
"fix"
"work"
```

---

## **الخطوة 🔟: التحقق من GitHub**

بعد الـ Push:

1. اذهب إلى: https://github.com/YOUR_USERNAME/SmartClinic-Database
2. ستظهر جميع الملفات
3. ستظهر قائمة بـ Commits
4. ستظهر README.md محسّنة

---

## **أوامر Git المهمة (مرجع سريع)**

### **عرض الحالة:**
```bash
git status              # حالة المشروع
git log                 # سجل الـ Commits
git log --oneline       # الـ Commits مختصرة
```

### **إضافة وحفظ:**
```bash
git add .               # إضافة جميع الملفات
git add filename.txt    # إضافة ملف محدد
git commit -m "message" # Commit مع رسالة
git push origin main    # رفع إلى GitHub
```

### **تحديث من GitHub:**
```bash
git pull origin main    # تحديث الملفات من GitHub
```

### **إذا أخطأت:**
```bash
git revert HEAD         # التراجع عن آخر commit
git reset --hard HEAD~1 # حذف آخر commit (احذر!)
```

---

## **الخطوة 11️⃣: ملفات Project Artifacts**

بعد رفع المشروع، أضف هذا القسم في **Project_Report.docx:**

```
# Project Artifacts

## Links to Project Resources

### Live Report Document (with Edit History)
[اختياري - إذا استخدمت Google Docs أو Word Online]
Link: https://docs.google.com/document/d/YOUR_DOC_ID

### GitHub Repository (with Commit History)
Repository URL: https://github.com/YOUR_USERNAME/SmartClinic-Database
Commits Count: [عدد الـ commits]
Last Commit: [تاريخ آخر commit]

### Database SQL Script
Location: database/SmartClinic.sql
Size: [حجم الملف]
Tables: 13
Records: 65+ (5+ per table)

### Query Scripts
Location: queries/ directory
Includes:
- select-queries.sql
- join-queries.sql
- nested-queries.sql
- aggregate-queries.sql
- update-delete.sql
- view-creation.sql
- trigger-creation.sql

### Screenshots
Location: screenshots/ directory
Includes:
- Database tables (13 screenshots)
- Query results (10+ screenshots)
- ER/EER diagram (1 screenshot)
```

---

## **الخطوة 12️⃣: تقييم النهائي**

### **قبل الإرسال، تحقق من:**

- ✅ المستودع عام (Public)
- ✅ جميع الملفات مرفوعة
- ✅ README.md موجود وكامل
- ✅ .gitignore موجود
- ✅ folder structure صحيح
- ✅ 5+ commits بـ messages واضحة
- ✅ SmartClinic.sql في مجلد database/
- ✅ جميع التقارير في مجلد documentation/
- ✅ جميع الصور في مجلد screenshots/
- ✅ جميع الاستعلامات في مجلد queries/

### **الرابط النهائي للإرسال:**
```
https://github.com/YOUR_USERNAME/SmartClinic-Database
```

---

## **أمثلة على Commit Messages الصحيحة**

```bash
git commit -m "Initial project setup: Add README and .gitignore"

git commit -m "Create Employee table with specialization hierarchy"

git commit -m "Implement Doctor, Nurse, Receptionist subclasses"

git commit -m "Add patient and appointment tables with constraints"

git commit -m "Insert sample data: 5+ records per table"

git commit -m "Implement SELECT statements for patient queries"

git commit -m "Add JOIN queries for multi-table relationships"

git commit -m "Create nested queries and aggregate functions"

git commit -m "Implement UPDATE and DELETE statements"

git commit -m "Create DoctorAppointmentView and Triggers"

git commit -m "Add documentation: README and setup guide"

git commit -m "Add screenshots: database tables and query results"

git commit -m "Final submission: Complete project ready for grading"
```

---

## **استكشاف الأخطاء الشائعة**

### **❌ خطأ: "fatal: not a git repository"**
**الحل:**
```bash
cd SmartClinic-Database/
git init
```

### **❌ خطأ: "permission denied" عند الـ Push**
**الحل:**
- استخدم Personal Access Token بدل كلمة المرور
- تحقق من أن username صحيح

### **❌ خطأ: "branch master not found"**
**الحل:**
```bash
git branch -M main
git push -u origin main
```

### **❌ خطأ: لم أستطع تذكر آخر رسالة commit**
**الحل:**
```bash
git log --oneline | head -5
```

---

## **نصائح ذهبية** 💡

1. **Commit كثيراً** - كل ما تكمل جزء من المشروع
2. **رسائل واضحة** - اشرح ماذا غيّرت
3. **لا تأخر الـ Push** - ادفع التغييرات يومياً
4. **اقرأ الأخطاء** - Git يخبرك بالمشكلة عادة
5. **استخدم .gitignore** - لا ترفع ملفات غير ضرورية
6. **اطلب مساعدة** - إذا علقت، ابحث عن الحل

---

## **المساعدة والموارد**

- **GitHub Docs:** https://docs.github.com
- **Git Tutorial:** https://git-scm.com/book
- **GitHub Desktop** (واجهة سهلة): https://desktop.github.com
- **الدعم:** اسأل في منتديات GitHub أو Stack Overflow

---

**آخر تحديث:** 2026-08-02  
**Status:** ✅ جاهز للبدء

---

### ✨ تهانينا! أنتم الآن جاهزون لرفع مشروعكم على GitHub!

