```css
VPC (Central Node)
│
├── DB Module
│   ├── Backend (TCP/3306)
│   ├── Bastion (TCP/3306)
│   └── VPN (TCP/3306)
│
├── Backend Module
│   ├── Private ALB / App ALB (TCP/8080)
│   ├── Bastion (TCP/22)
│   └── VPN (TCP/22, TCP/8080)
│
├── Private ALB / App ALB Module
│   ├── VPN (TCP/80)
│   ├── Bastion (TCP/80)
│   └── Frontend (TCP/80)
│
├── Frontend Module
│   ├── Public ALB / Web ALB (TCP/80)
│   ├── Bastion (TCP/22)
│   └── VPN (TCP/22)
│
├── Public ALB / Web ALB Module
│   └── Public (0.0.0.0/0) (TCP/80, TCP/443)
│
├── Bastion Module
│   └── Public (0.0.0.0/0) (TCP/22)
│
└── VPN Module
    └── Defined by var.vpn_sg_rules

```
Here’s a textual representation of your flowchart in a step-by-step format. You can use this structure in tools like Miro, Lucidchart, or any flowchart software.

### Flowchart Structure

- **VPC** (Central Node)

    - **DB Module**
        - Accepts ingress connections from:
            - **Backend** (TCP/3306)
            - **Bastion** (TCP/3306)
            - **VPN** (TCP/3306)

    - **Backend Module**
        - Accepts ingress connections from:
            - **Private ALB / App ALB** (TCP/8080)
            - **Bastion** (TCP/22)
            - **VPN** (TCP/22, TCP/8080)

    - **Private ALB / App ALB Module**
        - Accepts ingress connections from:
            - **VPN** (TCP/80)
            - **Bastion** (TCP/80)
            - **Frontend** (TCP/80)

    - **Frontend Module**
        - Accepts ingress connections from:
            - **Public ALB / Web ALB** (TCP/80)
            - **Bastion** (TCP/22)
            - **VPN** (TCP/22)

    - **Public ALB / Web ALB Module**
        - Accepts ingress connections from:
            - **Public (0.0.0.0/0)** (TCP/80, TCP/443)

    - **Bastion Module**
        - Accepts ingress connections from:
            - **Public (0.0.0.0/0)** (TCP/22)

    - **VPN Module**
        - Defined by `var.vpn_sg_rules`

### Flowchart Explanation:

1. **Start with VPC** at the center.
2. **DB Module** connects to **Backend**, **Bastion**, and **VPN** via port 3306 (MySQL).
3. **Backend Module** connects to **Private ALB / App ALB**, **VPN**, and **Bastion** via ports 22 (SSH) and 8080 (HTTP).
4. **Private ALB / App ALB Module** connects to **VPN**, **Bastion**, and **Frontend** via port 80 (HTTP).
5. **Frontend Module** connects to **Public ALB / Web ALB**, **Bastion**, and **VPN**.
6. **Public ALB / Web ALB Module** allows **Public** access via ports 80 (HTTP) and 443 (HTTPS).
7. **Bastion Module** allows **Public** access via port 22 (SSH).
8. **VPN Module** connections are defined by custom rules (`var.vpn_sg_rules`).

You can visually represent this with the central VPC node and connections radiating to the modules.