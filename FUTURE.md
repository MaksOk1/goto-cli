# Future Concepts & Ideas (плани на майбутнє)

Усі ідеї, потенційні покращення та архітектурні зміни, які виглядають перспективно, документуються в цьому файлі.

## Fast review (швидкий перегляд)
<!-- Тут: коротко про всі зміни, що плануються -->
* lib папка з функціями для простого логування й меншої кількості написання [OK] and [FAIL]
* config/ для вибору назв блоків, й інші додаткові налаштування
* prevent install over install
* make lib/makefile dir for more makefile checks outside of main file
* make i18n for project
* make color-coding for project
* add autocomplete with tab to project
* add `goto --add` command that will take name of project as current dir name and path is $pwd
* add `goto --merge` for merging projeectnames for same dirs with Diff view and interactive choosing of the project name

## 🚀 High Priority (найближчі плани)
<!-- Тут: те, що варто зробити в першу чергу та що критично для проєкту вже ось зараз -->
* **Покращення логування:** lib папка з функціями для простого логування й меншої кількості написання [OK]/[FAIL];
* **Нова структура конфігурації:** config/ для вибору назв блоків, й інші додаткові налаштування.
* **Безпека інсталяції:** prevent install over install (захист від повторного встановлення поверх існуючої версії).

## 🛠️ Architecture & Code Base (архітектура й рефакторинг коду)
<!-- Тут: зміни структури коду, нові модулі, реорганізацію файлів та автоматизацію -->
* **Модульність збірки:** make lib/makefile dir for more makefile checks outside of main file (винесення перевірок в окремі мейкфайли).

## 💡 Backlog (беклог)
<!-- Тут: масштабні завдання, або круті ідеї (найближчим часом) -->
* `none`

## 💡 Backburner (перспективні ідеї)
<!-- Тут: масштабні завдання, або круті ідеї (без точних термінів) -->
* **Локалізація:** make i18n for project (інтернаціоналізація / підтримка кількох мов).

## 🎨 UI/UX Ideas (можливі зміни інтерфейсу)
<!-- Тут все, що стосується покращення вигляду консолі, кольорів, виводу чи інтерфейсу -->
* **Колоркодинг:** make color-coding for project (зробити термінал кольоровим).
