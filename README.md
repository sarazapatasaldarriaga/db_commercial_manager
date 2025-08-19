## Configuración de Permisos de Terraform

Para la ejecución de Terraform, es crucial que el usuario o rol de IAM tenga los permisos adecuados para crear y gestionar los recursos de AWS. Dado que los recursos no existen previamente, se requiere un enfoque dinámico para la asignación de permisos.

Se han incluido dos scripts en el directorio `deployment/terraform/scripts/`:
1.  `setup_terraform_permissions.ps1`: para entornos Windows/PowerShell
2.  `setup_terraform_permissions.sh`: para entornos Linux/macOS/WSL
Ambos scripts automatizan la creación del rol `TerraformExecutionRoleDB` y la asignación de políticas necesarias para operar con Terraform.


**Uso del Script de Permisos:**
En Windows/PowerShell:
1.  Asegúrate de tener la AWS CLI configurada y autenticada con un usuario que tenga permisos para crear roles y políticas de IAM.
2.  Navega al directorio `deployment/terraform/scripts/`.
3.  Ejecuta el script de PowerShell:
    ```powershell
    .\setup_terraform_permissions.ps1
    ```
En Linux/macOS/WSL:
1.  Asegúrate de tener la AWS CLI configurada y autenticada con un usuario que tenga permisos para crear roles y políticas de IAM.
2.  Navega al directorio `deployment/terraform/scripts/`.
3.  Ejecuta el script de Bash:
    ```bash
    ./setup_terraform_permissions.sh
    ```

Este script creará un rol de IAM llamado `TerraformExecutionRoleDB` y adjuntará políticas que otorgan permisos para gestionar recursos de S3, CodePipeline, CodeBuild, IAM, VPC, ECR y ECS. El rol tendrá una política de confianza que permite al usuario que ejecuta el script asumirlo.

**Importante:** Este script otorga permisos significativos. Se recomienda que sea ejecutado por un administrador de AWS y que el rol `TerraformExecutionRoleDB` sea asumido por el usuario que ejecutará Terraform, en lugar de usar credenciales de usuario con permisos elevados directamente.

**Archivos de Datos (.ps1 y .sh):**

Si tienes scripts adicionales (por ejemplo, `.sh` para entornos Linux/macOS) que complementen la configuración o gestión de Terraform, se recomienda colocarlos también en el directorio `deployment/terraform/scripts/`.

*   **Consideraciones de Seguridad:** Si estos scripts contienen información sensible (claves API, secretos, etc.), **NO** los incluyas en el control de versiones. En su lugar, proporciona plantillas (ej. `script_name.ps1.template`, `script_name.sh.template`) e instruye a los usuarios a copiarlas y rellenarlas con sus propios valores.
*   **Documentación:** Asegúrate de documentar el propósito y el uso de cualquier script adicional en este `README.md` o en un archivo `README.md` específico dentro del directorio `scripts`.
