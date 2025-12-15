#  Junior Cloud Engineer Portfolio - Projekty AWS (IaC & Automation)

To repozytorium zawiera kolekcję projektów praktycznych zrealizowanych na platformie AWS, mających na celu udowodnienie kompetencji w zakresie Infrastructure as Code (IaC) oraz automatyzacji procesów chmurowych.

##  01-terraform-vpc: Wdrożenie Bezpiecznej Sieci VPC

### Cel Projektu
Zaprojektowanie i wdrożenie od podstaw kompletnej, 2-warstwowej, bezpiecznej sieci Virtual Private Cloud (VPC) w Amazon Web Services (AWS) z wykorzystaniem **Terraforma**.

### Architektura
Projekt implementuje kluczowe elementy infrastruktury sieciowej:
* **VPC:** Główna sieć zdefiniowana w regionie.
* **Podsieci:** Jedna podsieć publiczna (dla bramy dostępu) oraz jedna podsieć prywatna (dla serwerów aplikacyjnych/baz danych).
* **NAT Gateway:** Kluczowy element umożliwiający serwerom w podsieci prywatnej dostęp do Internetu (np. w celu pobrania aktualizacji) bez ujawniania ich światu zewnętrznemu.
* **Routing:** Poprawne skonfigurowanie tabel routingu dla obu podsieci.
* **EC2 Instance:** Wdrożenie instancji testowej w podsieci prywatnej w celu weryfikacji poprawnego działania routingu przez NAT Gateway.

### Uruchomienie
1.  Upewnij się, że masz skonfigurowane **AWS CLI** i dostęp do **Terraforma**.
2.  Przejdź do katalogu `01-terraform-vpc`.
3.  Uruchom `terraform init`.
4.  Uruchom `terraform apply`.

##  02-python-auditor: Automatyzacja i Zarządzanie Zasobami

### Cel Projektu
Demonstracja umiejętności programowego zarządzania i interakcji z API AWS przy użyciu **Pythona** i oficjalnego zestawu narzędzi **AWS SDK (Boto3)**.

### Funkcjonalność
Skrypt realizuje zadania typowe dla inżyniera Cloud/Security, automatycznie sprawdzając stan konta:
1.  **Audyt S3:** Skanuje wszystkie koszyki S3 i sygnalizuje te, które mają potencjalnie włączony publiczny dostęp (jest to krytyczny błąd bezpieczeństwa).
3.  **Audyt IAM:** Sprawdza wszystkich użytkowników i alarmuje, jeśli mają aktywne klucze dostępu (`Access Keys`), ale **nie mają włączonej weryfikacji Wieloskładnikowej (MFA)** – co jest poważnym ryzykiem.

### Uruchomienie
1.  Upewnij się, że masz zainstalowane biblioteki: `pip install boto3`.
2.  Przejdź do katalogu `02-python-auditor`.
3.  Uruchom skrypt: `python aws_auditor.py`.
