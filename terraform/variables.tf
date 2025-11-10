variable "project_id" {
  description = "ID del proyecto en GCP"
  type        = string
}

variable "region" {
  description = "Región de GCP (por ejemplo: us-central1, europe-west1)"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona de GCP (por ejemplo: us-central1-a, europe-west1-b)"
  type        = string
  default     = "us-central1-a"
}

variable "image" {
  description = "Imagen del sistema (por ejemplo: ubuntu-os-cloud/ubuntu-2204-lts)"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "machine_type" {
  description = "Tipo de máquina de GCP"
  type        = string
  default     = "e2-medium" # 2 vCPU, 4 GB RAM
}

variable "instance_name" {
  description = "Nombre de la instancia"
  type        = string
  default     = "kanbista-multistage"
}

variable "ssh_username" {
  description = "Usuario para la clave SSH en metadata"
  type        = string
  default     = "ubuntu"
}

variable "credentials_file" {
  description = "Ruta al archivo JSON de la cuenta de servicio"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Ruta al archivo de llave pública SSH (ej: /Users/tuusuario/.ssh/id_rsa.pub)"
  type        = string
}
