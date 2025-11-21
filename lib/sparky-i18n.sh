#!/bin/bash
# sparky-i18n.sh - Internationalization library for SparkyOS
# Copyright SparkyOS Team
# Under the GNU GPL3 License
#
# This library provides multilanguage string support for all Debian-supported languages
# Last update 2025/11/21

# Detect system language or use default
detect_language() {
    local lang="${LANG%%.*}"
    lang="${lang%%_*}"

    # Default to English if language not detected
    if [ -z "$lang" ]; then
        lang="en"
    fi

    echo "$lang"
}

# Get translated string
# Usage: get_string "KEY_NAME" [language]
get_string() {
    local key="$1"
    local lang="${2:-$(detect_language)}"

    # Declare all language strings as associative arrays
    declare -A strings

    case "$key" in
        # Application titles
        "APP_TITLE")
            case "$lang" in
                ar) echo "مدير خدمات SparkyOS" ;;
                bg) echo "SparkyOS Мениджър на услугите" ;;
                ca) echo "Gestor de Serveis SparkyOS" ;;
                cs) echo "Správce služeb SparkyOS" ;;
                da) echo "SparkyOS Tjeneste Manager" ;;
                de) echo "SparkyOS Dienst-Manager" ;;
                el) echo "Διαχειριστής Υπηρεσιών SparkyOS" ;;
                es) echo "Gestor de Servicios SparkyOS" ;;
                et) echo "SparkyOS Teenuste Haldur" ;;
                eu) echo "SparkyOS Zerbitzu Kudeatzailea" ;;
                fi) echo "SparkyOS Palveluhallinta" ;;
                fr) echo "Gestionnaire de Services SparkyOS" ;;
                gl) echo "Xestor de Servizos SparkyOS" ;;
                he) echo "מנהל שירותים SparkyOS" ;;
                hr) echo "SparkyOS Upravitelj Usluga" ;;
                hu) echo "SparkyOS Szolgáltatáskezelő" ;;
                id) echo "Pengelola Layanan SparkyOS" ;;
                it) echo "Gestore Servizi SparkyOS" ;;
                ja) echo "SparkyOS サービスマネージャー" ;;
                ko) echo "SparkyOS 서비스 관리자" ;;
                lt) echo "SparkyOS Paslaugų Valdytojas" ;;
                lv) echo "SparkyOS Pakalpojumu Pārvaldnieks" ;;
                nb|no) echo "SparkyOS Tjeneste Manager" ;;
                nl) echo "SparkyOS Servicebeheer" ;;
                pl) echo "Menedżer Usług SparkyOS" ;;
                pt) echo "Gestor de Serviços SparkyOS" ;;
                ro) echo "Manager Servicii SparkyOS" ;;
                ru) echo "Менеджер Служб SparkyOS" ;;
                sk) echo "Správca Služieb SparkyOS" ;;
                sl) echo "Upravitelj Storitev SparkyOS" ;;
                sr) echo "SparkyOS Менаџер Услуга" ;;
                sv) echo "SparkyOS Tjänstehanterare" ;;
                tr) echo "SparkyOS Servis Yöneticisi" ;;
                uk) echo "Менеджер Служб SparkyOS" ;;
                vi) echo "Quản Lý Dịch Vụ SparkyOS" ;;
                zh) echo "SparkyOS 服务管理器" ;;
                *) echo "SparkyOS Service Manager" ;;
            esac
            ;;

        "APP_DESCRIPTION")
            case "$lang" in
                ar) echo "إدارة الخدمات وجدولة الإشعارات الصوتية" ;;
                bg) echo "Управление на услуги и планиране на звукови известия" ;;
                ca) echo "Gestió de serveis i programació de notificacions de so" ;;
                cs) echo "Správa služeb a plánování zvukových upozornění" ;;
                da) echo "Styring af tjenester og planlægning af lydnotifikationer" ;;
                de) echo "Dienstverwaltung und Zeitplanung von Tonbenachrichtigungen" ;;
                el) echo "Διαχείριση υπηρεσιών και προγραμματισμός ηχητικών ειδοποιήσεων" ;;
                es) echo "Gestión de servicios y programación de notificaciones de sonido" ;;
                et) echo "Teenuste haldamine ja heliteavituste ajastamine" ;;
                eu) echo "Zerbitzuen kudeaketa eta soinu jakinarazpenen programazioa" ;;
                fi) echo "Palveluiden hallinta ja ääni-ilmoitusten ajastus" ;;
                fr) echo "Gestion des services et planification des notifications sonores" ;;
                gl) echo "Xestión de servizos e programación de notificacións de son" ;;
                he) echo "ניהול שירותים ותזמון התראות קוליות" ;;
                hr) echo "Upravljanje uslugama i planiranje zvučnih obavijesti" ;;
                hu) echo "Szolgáltatások kezelése és hangértesítések ütemezése" ;;
                id) echo "Pengelolaan layanan dan penjadwalan notifikasi suara" ;;
                it) echo "Gestione servizi e pianificazione notifiche sonore" ;;
                ja) echo "サービス管理とサウンド通知のスケジューリング" ;;
                ko) echo "서비스 관리 및 사운드 알림 예약" ;;
                lt) echo "Paslaugų valdymas ir garso pranešimų planavimas" ;;
                lv) echo "Pakalpojumu pārvaldība un skaņas paziņojumu plānošana" ;;
                nb|no) echo "Tjenestestyring og planlegging av lydvarsler" ;;
                nl) echo "Servicebeheer en planning van geluidsnotificaties" ;;
                pl) echo "Zarządzanie usługami i planowanie powiadomień dźwiękowych" ;;
                pt) echo "Gestão de serviços e agendamento de notificações sonoras" ;;
                ro) echo "Gestionarea serviciilor și programarea notificărilor sonore" ;;
                ru) echo "Управление службами и планирование звуковых уведомлений" ;;
                sk) echo "Správa služieb a plánovanie zvukových upozornení" ;;
                sl) echo "Upravljanje storitev in načrtovanje zvočnih obvestil" ;;
                sr) echo "Управљање услугама и заказивање звучних обавештења" ;;
                sv) echo "Tjänstehantering och schemaläggning av ljudnotifikationer" ;;
                tr) echo "Servis yönetimi ve ses bildirimleri zamanlama" ;;
                uk) echo "Керування службами та планування звукових сповіщень" ;;
                vi) echo "Quản lý dịch vụ và lên lịch thông báo âm thanh" ;;
                zh) echo "服务管理和声音通知计划" ;;
                *) echo "Service management and sound notification scheduling" ;;
            esac
            ;;

        "MENU_SERVICE_MANAGER")
            case "$lang" in
                ar) echo "مدير الخدمات" ;;
                bg) echo "Мениджър на услугите" ;;
                ca) echo "Gestor de Serveis" ;;
                cs) echo "Správce služeb" ;;
                da) echo "Tjeneste Manager" ;;
                de) echo "Dienst-Manager" ;;
                el) echo "Διαχειριστής Υπηρεσιών" ;;
                es) echo "Gestor de Servicios" ;;
                et) echo "Teenuste Haldur" ;;
                eu) echo "Zerbitzu Kudeatzailea" ;;
                fi) echo "Palveluhallinta" ;;
                fr) echo "Gestionnaire de Services" ;;
                gl) echo "Xestor de Servizos" ;;
                he) echo "מנהל שירותים" ;;
                hr) echo "Upravitelj Usluga" ;;
                hu) echo "Szolgáltatáskezelő" ;;
                id) echo "Pengelola Layanan" ;;
                it) echo "Gestore Servizi" ;;
                ja) echo "サービスマネージャー" ;;
                ko) echo "서비스 관리자" ;;
                lt) echo "Paslaugų Valdytojas" ;;
                lv) echo "Pakalpojumu Pārvaldnieks" ;;
                nb|no) echo "Tjeneste Manager" ;;
                nl) echo "Servicebeheer" ;;
                pl) echo "Menedżer Usług" ;;
                pt) echo "Gestor de Serviços" ;;
                ro) echo "Manager Servicii" ;;
                ru) echo "Менеджер Служб" ;;
                sk) echo "Správca Služieb" ;;
                sl) echo "Upravitelj Storitev" ;;
                sr) echo "Менаџер Услуга" ;;
                sv) echo "Tjänstehanterare" ;;
                tr) echo "Servis Yöneticisi" ;;
                uk) echo "Менеджер Служб" ;;
                vi) echo "Quản Lý Dịch Vụ" ;;
                zh) echo "服务管理器" ;;
                *) echo "Service Manager" ;;
            esac
            ;;

        "MENU_TUNE_SCHEDULER")
            case "$lang" in
                ar) echo "جدولة الإشعارات الصوتية" ;;
                bg) echo "Планиране на звукови известия" ;;
                ca) echo "Programador de So" ;;
                cs) echo "Plánovač zvuku" ;;
                da) echo "Lydplanlægning" ;;
                de) echo "Tonplaner" ;;
                el) echo "Προγραμματιστής Ήχου" ;;
                es) echo "Programador de Sonido" ;;
                et) echo "Heli Ajastaja" ;;
                eu) echo "Soinu Programatzailea" ;;
                fi) echo "Ääniajastin" ;;
                fr) echo "Planificateur de Son" ;;
                gl) echo "Programador de Son" ;;
                he) echo "מתזמן צלילים" ;;
                hr) echo "Planer Zvuka" ;;
                hu) echo "Hangütemező" ;;
                id) echo "Penjadwal Suara" ;;
                it) echo "Pianificatore Audio" ;;
                ja) echo "サウンドスケジューラー" ;;
                ko) echo "사운드 스케줄러" ;;
                lt) echo "Garso Planuotojas" ;;
                lv) echo "Skaņas Plānotājs" ;;
                nb|no) echo "Lydplanlegger" ;;
                nl) echo "Geluidsplanner" ;;
                pl) echo "Harmonogram Dźwięku" ;;
                pt) echo "Agendador de Som" ;;
                ro) echo "Planificator Sunet" ;;
                ru) echo "Планировщик Звуков" ;;
                sk) echo "Plánovač Zvuku" ;;
                sl) echo "Načrtovalnik Zvoka" ;;
                sr) echo "Планер Звука" ;;
                sv) echo "Ljudschemaläggare" ;;
                tr) echo "Ses Zamanlayıcı" ;;
                uk) echo "Планувальник Звуків" ;;
                vi) echo "Lập Lịch Âm Thanh" ;;
                zh) echo "声音调度器" ;;
                *) echo "Tune Scheduler" ;;
            esac
            ;;

        "MENU_VIEW_CONFIG")
            case "$lang" in
                ar) echo "عرض التكوين" ;;
                bg) echo "Преглед на конфигурацията" ;;
                ca) echo "Veure Configuració" ;;
                cs) echo "Zobrazit Konfiguraci" ;;
                da) echo "Vis Konfiguration" ;;
                de) echo "Konfiguration Anzeigen" ;;
                el) echo "Προβολή Ρυθμίσεων" ;;
                es) echo "Ver Configuración" ;;
                et) echo "Vaata Seadistust" ;;
                eu) echo "Ikusi Konfigurazioa" ;;
                fi) echo "Näytä Asetukset" ;;
                fr) echo "Voir la Configuration" ;;
                gl) echo "Ver Configuración" ;;
                he) echo "הצג תצורה" ;;
                hr) echo "Prikaži Konfiguraciju" ;;
                hu) echo "Konfiguráció Megtekintése" ;;
                id) echo "Lihat Konfigurasi" ;;
                it) echo "Visualizza Configurazione" ;;
                ja) echo "設定を表示" ;;
                ko) echo "설정 보기" ;;
                lt) echo "Peržiūrėti Konfigūraciją" ;;
                lv) echo "Skatīt Konfigurāciju" ;;
                nb|no) echo "Vis Konfigurasjon" ;;
                nl) echo "Configuratie Bekijken" ;;
                pl) echo "Zobacz Konfigurację" ;;
                pt) echo "Ver Configuração" ;;
                ro) echo "Vezi Configurația" ;;
                ru) echo "Просмотр Конфигурации" ;;
                sk) echo "Zobraziť Konfiguráciu" ;;
                sl) echo "Prikaži Konfiguracijo" ;;
                sr) echo "Прикажи Конфигурацију" ;;
                sv) echo "Visa Konfiguration" ;;
                tr) echo "Yapılandırmayı Göster" ;;
                uk) echo "Переглянути Конфігурацію" ;;
                vi) echo "Xem Cấu Hình" ;;
                zh) echo "查看配置" ;;
                *) echo "View Configuration" ;;
            esac
            ;;

        "MENU_EXIT")
            case "$lang" in
                ar) echo "خروج" ;;
                bg) echo "Изход" ;;
                ca) echo "Sortir" ;;
                cs) echo "Konec" ;;
                da) echo "Afslut" ;;
                de) echo "Beenden" ;;
                el) echo "Έξοδος" ;;
                es) echo "Salir" ;;
                et) echo "Välju" ;;
                eu) echo "Irten" ;;
                fi) echo "Poistu" ;;
                fr) echo "Quitter" ;;
                gl) echo "Saír" ;;
                he) echo "יציאה" ;;
                hr) echo "Izlaz" ;;
                hu) echo "Kilépés" ;;
                id) echo "Keluar" ;;
                it) echo "Esci" ;;
                ja) echo "終了" ;;
                ko) echo "종료" ;;
                lt) echo "Išeiti" ;;
                lv) echo "Iziet" ;;
                nb|no) echo "Avslutt" ;;
                nl) echo "Afsluiten" ;;
                pl) echo "Wyjście" ;;
                pt) echo "Sair" ;;
                ro) echo "Ieșire" ;;
                ru) echo "Выход" ;;
                sk) echo "Koniec" ;;
                sl) echo "Izhod" ;;
                sr) echo "Излаз" ;;
                sv) echo "Avsluta" ;;
                tr) echo "Çıkış" ;;
                uk) echo "Вихід" ;;
                vi) echo "Thoát" ;;
                zh) echo "退出" ;;
                *) echo "Exit" ;;
            esac
            ;;

        "SELECT_SERVICES")
            case "$lang" in
                ar) echo "حدد الخدمات للمراقبة:" ;;
                bg) echo "Изберете услуги за наблюдение:" ;;
                ca) echo "Selecciona els serveis per monitoritzar:" ;;
                cs) echo "Vyberte služby ke sledování:" ;;
                da) echo "Vælg tjenester til overvågning:" ;;
                de) echo "Wählen Sie Dienste zur Überwachung:" ;;
                el) echo "Επιλέξτε υπηρεσίες για παρακολούθηση:" ;;
                es) echo "Seleccione servicios para monitorear:" ;;
                et) echo "Valige teenused jälgimiseks:" ;;
                eu) echo "Hautatu zerbitzuak monitorizatzeko:" ;;
                fi) echo "Valitse valvottavat palvelut:" ;;
                fr) echo "Sélectionnez les services à surveiller:" ;;
                gl) echo "Seleccione servizos para supervisar:" ;;
                he) echo "בחר שירותים לניטור:" ;;
                hr) echo "Odaberite usluge za praćenje:" ;;
                hu) echo "Válassza ki a megfigyelendő szolgáltatásokat:" ;;
                id) echo "Pilih layanan untuk dipantau:" ;;
                it) echo "Seleziona i servizi da monitorare:" ;;
                ja) echo "監視するサービスを選択:" ;;
                ko) echo "모니터링할 서비스 선택:" ;;
                lt) echo "Pasirinkite paslaugas stebėjimui:" ;;
                lv) echo "Izvēlieties pakalpojumus uzraudzībai:" ;;
                nb|no) echo "Velg tjenester å overvåke:" ;;
                nl) echo "Selecteer te bewaken services:" ;;
                pl) echo "Wybierz usługi do monitorowania:" ;;
                pt) echo "Selecione serviços para monitorar:" ;;
                ro) echo "Selectați serviciile de monitorizat:" ;;
                ru) echo "Выберите службы для мониторинга:" ;;
                sk) echo "Vyberte služby na sledovanie:" ;;
                sl) echo "Izberite storitve za nadzor:" ;;
                sr) echo "Изаберите услуге за праћење:" ;;
                sv) echo "Välj tjänster att övervaka:" ;;
                tr) echo "İzlenecek servisleri seçin:" ;;
                uk) echo "Виберіть служби для моніторингу:" ;;
                vi) echo "Chọn dịch vụ để giám sát:" ;;
                zh) echo "选择要监控的服务:" ;;
                *) echo "Select services to monitor:" ;;
            esac
            ;;

        "SELECT_TUNE")
            case "$lang" in
                ar) echo "حدد النغمة:" ;;
                bg) echo "Изберете мелодия:" ;;
                ca) echo "Selecciona el to:" ;;
                cs) echo "Vyberte melodii:" ;;
                da) echo "Vælg melodi:" ;;
                de) echo "Wählen Sie die Melodie:" ;;
                el) echo "Επιλέξτε μελωδία:" ;;
                es) echo "Seleccione tono:" ;;
                et) echo "Valige meloodia:" ;;
                eu) echo "Hautatu doinua:" ;;
                fi) echo "Valitse sävel:" ;;
                fr) echo "Sélectionnez la mélodie:" ;;
                gl) echo "Seleccione ton:" ;;
                he) echo "בחר צליל:" ;;
                hr) echo "Odaberite melodiju:" ;;
                hu) echo "Válassza ki a dallamot:" ;;
                id) echo "Pilih nada:" ;;
                it) echo "Seleziona suoneria:" ;;
                ja) echo "着信音を選択:" ;;
                ko) echo "벨소리 선택:" ;;
                lt) echo "Pasirinkite melodiją:" ;;
                lv) echo "Izvēlieties melodiju:" ;;
                nb|no) echo "Velg melodi:" ;;
                nl) echo "Selecteer toon:" ;;
                pl) echo "Wybierz dźwięk:" ;;
                pt) echo "Selecione tom:" ;;
                ro) echo "Selectați melodia:" ;;
                ru) echo "Выберите мелодию:" ;;
                sk) echo "Vyberte melódiu:" ;;
                sl) echo "Izberite melodijo:" ;;
                sr) echo "Изаберите мелодију:" ;;
                sv) echo "Välj melodi:" ;;
                tr) echo "Melodiyi seçin:" ;;
                uk) echo "Виберіть мелодію:" ;;
                vi) echo "Chọn giai điệu:" ;;
                zh) echo "选择音调:" ;;
                *) echo "Select tune:" ;;
            esac
            ;;

        "SELECT_TIME")
            case "$lang" in
                ar) echo "حدد الوقت (HH:MM):" ;;
                bg) echo "Изберете час (HH:MM):" ;;
                ca) echo "Selecciona l'hora (HH:MM):" ;;
                cs) echo "Vyberte čas (HH:MM):" ;;
                da) echo "Vælg tid (HH:MM):" ;;
                de) echo "Wählen Sie die Zeit (HH:MM):" ;;
                el) echo "Επιλέξτε ώρα (HH:MM):" ;;
                es) echo "Seleccione hora (HH:MM):" ;;
                et) echo "Valige aeg (HH:MM):" ;;
                eu) echo "Hautatu ordua (HH:MM):" ;;
                fi) echo "Valitse aika (HH:MM):" ;;
                fr) echo "Sélectionnez l'heure (HH:MM):" ;;
                gl) echo "Seleccione hora (HH:MM):" ;;
                he) echo "בחר שעה (HH:MM):" ;;
                hr) echo "Odaberite vrijeme (HH:MM):" ;;
                hu) echo "Válassza ki az időt (HH:MM):" ;;
                id) echo "Pilih waktu (HH:MM):" ;;
                it) echo "Seleziona orario (HH:MM):" ;;
                ja) echo "時間を選択 (HH:MM):" ;;
                ko) echo "시간 선택 (HH:MM):" ;;
                lt) echo "Pasirinkite laiką (HH:MM):" ;;
                lv) echo "Izvēlieties laiku (HH:MM):" ;;
                nb|no) echo "Velg tid (HH:MM):" ;;
                nl) echo "Selecteer tijd (HH:MM):" ;;
                pl) echo "Wybierz czas (HH:MM):" ;;
                pt) echo "Selecione hora (HH:MM):" ;;
                ro) echo "Selectați ora (HH:MM):" ;;
                ru) echo "Выберите время (HH:MM):" ;;
                sk) echo "Vyberte čas (HH:MM):" ;;
                sl) echo "Izberite čas (HH:MM):" ;;
                sr) echo "Изаберите време (HH:MM):" ;;
                sv) echo "Välj tid (HH:MM):" ;;
                tr) echo "Zamanı seçin (HH:MM):" ;;
                uk) echo "Виберіть час (HH:MM):" ;;
                vi) echo "Chọn thời gian (HH:MM):" ;;
                zh) echo "选择时间 (HH:MM):" ;;
                *) echo "Select time (HH:MM):" ;;
            esac
            ;;

        "SERVICE_STARTED")
            case "$lang" in
                ar) echo "الخدمة مبدوءة" ;;
                bg) echo "Услугата е стартирана" ;;
                ca) echo "Servei iniciat" ;;
                cs) echo "Služba spuštěna" ;;
                da) echo "Tjeneste startet" ;;
                de) echo "Dienst gestartet" ;;
                el) echo "Υπηρεσία ξεκίνησε" ;;
                es) echo "Servicio iniciado" ;;
                et) echo "Teenus käivitatud" ;;
                eu) echo "Zerbitzua hasita" ;;
                fi) echo "Palvelu käynnistetty" ;;
                fr) echo "Service démarré" ;;
                gl) echo "Servizo iniciado" ;;
                he) echo "שירות הופעל" ;;
                hr) echo "Usluga pokrenuta" ;;
                hu) echo "Szolgáltatás elindítva" ;;
                id) echo "Layanan dimulai" ;;
                it) echo "Servizio avviato" ;;
                ja) echo "サービス開始" ;;
                ko) echo "서비스 시작됨" ;;
                lt) echo "Paslauga paleista" ;;
                lv) echo "Pakalpojums sākts" ;;
                nb|no) echo "Tjeneste startet" ;;
                nl) echo "Service gestart" ;;
                pl) echo "Usługa uruchomiona" ;;
                pt) echo "Serviço iniciado" ;;
                ro) echo "Serviciu pornit" ;;
                ru) echo "Служба запущена" ;;
                sk) echo "Služba spustená" ;;
                sl) echo "Storitev zagnana" ;;
                sr) echo "Услуга покренута" ;;
                sv) echo "Tjänst startad" ;;
                tr) echo "Servis başlatıldı" ;;
                uk) echo "Служба запущена" ;;
                vi) echo "Dịch vụ đã khởi động" ;;
                zh) echo "服务已启动" ;;
                *) echo "Service started" ;;
            esac
            ;;

        "SERVICE_STOPPED")
            case "$lang" in
                ar) echo "الخدمة موقوفة" ;;
                bg) echo "Услугата е спряна" ;;
                ca) echo "Servei aturat" ;;
                cs) echo "Služba zastavena" ;;
                da) echo "Tjeneste stoppet" ;;
                de) echo "Dienst gestoppt" ;;
                el) echo "Υπηρεσία σταμάτησε" ;;
                es) echo "Servicio detenido" ;;
                et) echo "Teenus peatatud" ;;
                eu) echo "Zerbitzua geldituta" ;;
                fi) echo "Palvelu pysäytetty" ;;
                fr) echo "Service arrêté" ;;
                gl) echo "Servizo detido" ;;
                he) echo "שירות הופסק" ;;
                hr) echo "Usluga zaustavljena" ;;
                hu) echo "Szolgáltatás leállítva" ;;
                id) echo "Layanan dihentikan" ;;
                it) echo "Servizio arrestato" ;;
                ja) echo "サービス停止" ;;
                ko) echo "서비스 중지됨" ;;
                lt) echo "Paslauga sustabdyta" ;;
                lv) echo "Pakalpojums apturēts" ;;
                nb|no) echo "Tjeneste stoppet" ;;
                nl) echo "Service gestopt" ;;
                pl) echo "Usługa zatrzymana" ;;
                pt) echo "Serviço parado" ;;
                ro) echo "Serviciu oprit" ;;
                ru) echo "Служба остановлена" ;;
                sk) echo "Služba zastavená" ;;
                sl) echo "Storitev ustavljena" ;;
                sr) echo "Услуга заустављена" ;;
                sv) echo "Tjänst stoppad" ;;
                tr) echo "Servis durduruldu" ;;
                uk) echo "Служба зупинена" ;;
                vi) echo "Dịch vụ đã dừng" ;;
                zh) echo "服务已停止" ;;
                *) echo "Service stopped" ;;
            esac
            ;;

        "CONFIG_SAVED")
            case "$lang" in
                ar) echo "تم حفظ التكوين بنجاح" ;;
                bg) echo "Конфигурацията е запазена успешно" ;;
                ca) echo "Configuració desada correctament" ;;
                cs) echo "Konfigurace úspěšně uložena" ;;
                da) echo "Konfiguration gemt korrekt" ;;
                de) echo "Konfiguration erfolgreich gespeichert" ;;
                el) echo "Η ρύθμιση αποθηκεύτηκε επιτυχώς" ;;
                es) echo "Configuración guardada correctamente" ;;
                et) echo "Seadistus edukalt salvestatud" ;;
                eu) echo "Konfigurazioa ondo gorde da" ;;
                fi) echo "Asetukset tallennettu onnistuneesti" ;;
                fr) echo "Configuration enregistrée avec succès" ;;
                gl) echo "Configuración gardada correctamente" ;;
                he) echo "תצורה נשמרה בהצלחה" ;;
                hr) echo "Konfiguracija uspješno spremljena" ;;
                hu) echo "Konfiguráció sikeresen mentve" ;;
                id) echo "Konfigurasi berhasil disimpan" ;;
                it) echo "Configurazione salvata correttamente" ;;
                ja) echo "設定が正常に保存されました" ;;
                ko) echo "설정이 성공적으로 저장됨" ;;
                lt) echo "Konfigūracija sėkmingai išsaugota" ;;
                lv) echo "Konfigurācija veiksmīgi saglabāta" ;;
                nb|no) echo "Konfigurasjon lagret" ;;
                nl) echo "Configuratie succesvol opgeslagen" ;;
                pl) echo "Konfiguracja zapisana pomyślnie" ;;
                pt) echo "Configuração salva com sucesso" ;;
                ro) echo "Configurație salvată cu succes" ;;
                ru) echo "Конфигурация успешно сохранена" ;;
                sk) echo "Konfigurácia úspešne uložená" ;;
                sl) echo "Konfiguracija uspešno shranjena" ;;
                sr) echo "Конфигурација успешно сачувана" ;;
                sv) echo "Konfiguration sparad" ;;
                tr) echo "Yapılandırma başarıyla kaydedildi" ;;
                uk) echo "Конфігурація успішно збережена" ;;
                vi) echo "Cấu hình đã lưu thành công" ;;
                zh) echo "配置保存成功" ;;
                *) echo "Configuration saved successfully" ;;
            esac
            ;;

        "ERROR_ROOT_REQUIRED")
            case "$lang" in
                ar) echo "خطأ: مطلوب امتيازات الجذر (root)" ;;
                bg) echo "Грешка: Изискват се root привилегии" ;;
                ca) echo "Error: Es requereixen privilegis de root" ;;
                cs) echo "Chyba: Vyžadována práva root" ;;
                da) echo "Fejl: Root-privilegier påkrævet" ;;
                de) echo "Fehler: Root-Rechte erforderlich" ;;
                el) echo "Σφάλμα: Απαιτούνται δικαιώματα root" ;;
                es) echo "Error: Se requieren privilegios de root" ;;
                et) echo "Viga: Vajalikud on root õigused" ;;
                eu) echo "Errorea: Root pribilegioak behar dira" ;;
                fi) echo "Virhe: Root-oikeudet vaaditaan" ;;
                fr) echo "Erreur: Privilèges root requis" ;;
                gl) echo "Erro: Requírense privilexios de root" ;;
                he) echo "שגיאה: נדרשות הרשאות root" ;;
                hr) echo "Greška: Potrebne root privilegije" ;;
                hu) echo "Hiba: Root jogosultságok szükségesek" ;;
                id) echo "Kesalahan: Diperlukan hak akses root" ;;
                it) echo "Errore: Privilegi root richiesti" ;;
                ja) echo "エラー: root権限が必要です" ;;
                ko) echo "오류: root 권한 필요" ;;
                lt) echo "Klaida: Reikalingos root privilegijos" ;;
                lv) echo "Kļūda: Nepieciešamas root privilēģijas" ;;
                nb|no) echo "Feil: Root-privilegier kreves" ;;
                nl) echo "Fout: Root-rechten vereist" ;;
                pl) echo "Błąd: Wymagane uprawnienia root" ;;
                pt) echo "Erro: Privilégios root necessários" ;;
                ro) echo "Eroare: Necesită privilegii root" ;;
                ru) echo "Ошибка: Требуются права root" ;;
                sk) echo "Chyba: Vyžadujú sa práva root" ;;
                sl) echo "Napaka: Zahtevane root pravice" ;;
                sr) echo "Грешка: Потребне root привилегије" ;;
                sv) echo "Fel: Root-privilegier krävs" ;;
                tr) echo "Hata: Root yetkileri gerekli" ;;
                uk) echo "Помилка: Потрібні права root" ;;
                vi) echo "Lỗi: Yêu cầu quyền root" ;;
                zh) echo "错误: 需要root权限" ;;
                *) echo "Error: Root privileges required" ;;
            esac
            ;;

        "NO_SERVICES_SELECTED")
            case "$lang" in
                ar) echo "لم يتم تحديد أي خدمات" ;;
                bg) echo "Няма избрани услуги" ;;
                ca) echo "No s'han seleccionat serveis" ;;
                cs) echo "Nebyly vybrány žádné služby" ;;
                da) echo "Ingen tjenester valgt" ;;
                de) echo "Keine Dienste ausgewählt" ;;
                el) echo "Δεν επιλέχθηκαν υπηρεσίες" ;;
                es) echo "No se seleccionaron servicios" ;;
                et) echo "Teenuseid ei valitud" ;;
                eu) echo "Ez da zerbitzurik hautatu" ;;
                fi) echo "Palveluita ei valittu" ;;
                fr) echo "Aucun service sélectionné" ;;
                gl) echo "Non se seleccionaron servizos" ;;
                he) echo "לא נבחרו שירותים" ;;
                hr) echo "Nisu odabrane usluge" ;;
                hu) echo "Nem választott szolgáltatásokat" ;;
                id) echo "Tidak ada layanan yang dipilih" ;;
                it) echo "Nessun servizio selezionato" ;;
                ja) echo "サービスが選択されていません" ;;
                ko) echo "선택된 서비스 없음" ;;
                lt) echo "Nepasirinkta paslaugų" ;;
                lv) echo "Nav izvēlēti pakalpojumi" ;;
                nb|no) echo "Ingen tjenester valgt" ;;
                nl) echo "Geen services geselecteerd" ;;
                pl) echo "Nie wybrano usług" ;;
                pt) echo "Nenhum serviço selecionado" ;;
                ro) echo "Niciun serviciu selectat" ;;
                ru) echo "Службы не выбраны" ;;
                sk) echo "Nevybrané žiadne služby" ;;
                sl) echo "Nobene storitve niso izbrane" ;;
                sr) echo "Нису изабране услуге" ;;
                sv) echo "Inga tjänster valda" ;;
                tr) echo "Hiçbir servis seçilmedi" ;;
                uk) echo "Служби не вибрані" ;;
                vi) echo "Không có dịch vụ nào được chọn" ;;
                zh) echo "未选择任何服务" ;;
                *) echo "No services selected" ;;
            esac
            ;;

        *)
            echo "Unknown key: $key"
            ;;
    esac
}

# Export functions
export -f detect_language
export -f get_string
