# Infraestructura con Terraform (GCP) – Flujo de uso

Este proyecto aprovisiona una instancia de Compute Engine en GCP con Docker con el objetivo de multi-entorno.

## Requisitos previos
- Tener un proyecto en GCP y habilitada la API de Compute Engine.
- Crear una Cuenta de Servicio con permisos (recomendado: `Administrador de Compute`).
- Descargar la clave JSON de la Cuenta de Servicio.
- Llave SSH local existente en tu equipo: `~/.ssh/id_rsa` y `~/.ssh/id_rsa.pub`.

## Configuración de variables
Edita `terraform/terraform.tfvars` y establece:
- `project_id`: ID de tu proyecto GCP.
- `region` y `zone`: por ejemplo `us-central1` y `us-central1-a`.
- `credentials_file`: ruta al JSON de la Cuenta de Servicio (archivo local).
- `ssh_public_key_path`: ruta al archivo de llave pública SSH (por ejemplo `/Users/tuusuario/.ssh/id_rsa.pub`).

Ejemplo mínimo:
```
project_id   = "TU_PROJECT_ID"
region       = "us-central1"
zone         = "us-central1-a"
image        = "ubuntu-os-cloud/ubuntu-2204-lts"
machine_type = "e2-medium"
instance_name = "kanbista-proxy"
ssh_username  = "ubuntu"
credentials_file = "/ruta/a/tu-sa-key.json"
ssh_public_key_path = "/Users/tuusuario/.ssh/id_rsa.pub"
```

## Crear la infraestructura
1. Abre una terminal en `terraform/`:
   - `cd terraform`
2. Inicializa Terraform (descarga proveedores y prepara el estado):
   - `terraform init`
   - Espera ver mensajes de instalación de proveedores y la creación de la carpeta `.terraform`.
3. Previsualiza los cambios:
   - `terraform plan`
   - Verás el plan con los recursos que se crearán (instancia, firewalls). No realiza cambios todavía.
4. Aplica el plan (crea recursos):
   - `terraform apply -auto-approve`
   - Espera varios minutos mientras se crea la VM y se ejecuta el script de inicio que instala Docker, Fail2ban y lanza el proxy.

## Destruir la infraestructura
- Cuando quieras borrar todos los recursos creados por Terraform:
  - `terraform destroy -auto-approve`
- Espera que se eliminen la instancia y las reglas de firewall. Al terminar, no habrá cargos por esos recursos.

