# GitOps Status Checker Application

Prosty mikroserwis napisanay w Pythonie, służący do demonstracji pełnego cyklu wdrożeniowego w modelu GitOps przy użyciu Kubernetesa i ArgoCD.

## Architektura i Technologie
- Backend: Python (Flask)
- Konteneryzacja: Docker
- Orkiestracja: Kubernetes (Minikube)
- GitOps: ArgoCD
- Infrastruktura jako Kod (IaC): Manifesty YAML

## Funkcjonalności
- Automatyczne wdrażanie zmian po każdym `git push`.
- Skalowanie poziome (2 instancje aplikacji działające równolegle).
- Probes (Liveness & Readiness) zapewniające wysoką dostępność.
- Load Balancing ruchu przez Service typu LoadBalancer.

## Endpointy
- `GET /health` - zwraca status aplikacji, środowisko, architekturę procesora oraz nazwę Poda obsługującego żądanie.

## Jak uruchomić lokalnie
1. Zbuduj obraz: `docker build -t status-checker:v1 .`
2. Wdróż w klastrze: `kubectl apply -f deployment.yaml`
3. Udostępnij usługę: `minikube service status-checker-service`