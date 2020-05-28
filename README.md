Приложение для просмотра видео с сайта TJournal, с авторизацией по qr-коду.

API: https://cmtt-ru.github.io/osnova-api/swagger.html

Лента
========================

Экран для просмотра ленты подсайта Видео и гифки TJournal (https://tjournal.ru/gifv)

Используя роут /subsite/{id}/timeline/{sorting} необходимо отобразить ленту постов подсайта, которая подгружается по мере прокрутки.

Пост должен состоять из заголовка и картинки или видео.

Видео должны автоматически проигрываться по мере скроллинга.

Профиль
========================
Экран для просмотра основных сведений личного профиля на сайте.

Если пользователь не авторизован, на экране должна отображаться кнопка Авторизоваться. По нажатию на кнопку пользователь может авторизоваться по QR коду.

Если пользователь авторизован, на экране отображается его аватарка, имя пользователя и кнопка Выйти.
