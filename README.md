# Supabase Self-Hosted sur Dokploy

Configuration complete pour deployer Supabase en self-hosted sur Dokploy.

## Services inclus

- **PostgreSQL 15** - Base de donnees principale
- **Kong** - API Gateway (port 8000)
- **PostgREST** - API REST automatique
- **GoTrue** - Service d'authentification
- **Storage API** - Stockage de fichiers
- **Realtime** - WebSockets et temps reel
- **Studio** - Dashboard UI (port 3000)
- **Meta** - API de gestion PostgreSQL
- **Imgproxy** - Transformation d'images
- **Edge Functions** - Fonctions serverless
- **Analytics** - Logflare pour les logs

## Deploiement sur Dokploy

### 1. Creer un service Compose

1. Dans Dokploy, creez un nouveau projet
2. Ajoutez un service de type "Compose"
3. Selectionnez "Git Repository" ou uploadez les fichiers

### 2. Configurer les variables d'environnement

Dans Dokploy, ajoutez ces variables d'environnement (section "Environment"):

```env
# Secrets critiques
POSTGRES_PASSWORD=K8mP2xNq7vR9sT4wY6zA3bC5dE8fG1hJ
JWT_SECRET=Wx9Kp2Nm5Qr8Tv3Yz6Bc1Df4Gh7Jk0Ls
DASHBOARD_PASSWORD=Rt5Yh8Km2Nq6Pw9Sx3Vz1Bc4Df7Gj0Lm

# API Keys
ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNzMyNDcwNDAwLCJleHAiOjE5ODg3NzA0MDB9.Kx5Nt2Lm8Pq1Rv4Sw7Tz0Wc3Yf6Zh9Bk2Dn5Gj8Jm0
SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJvbGUiOiJzZXJ2aWNlX3JvbGUiLCJpYXQiOjE3MzI0NzA0MDAsImV4cCI6MTk4ODc3MDQwMH0.Xm3Nq6Pj9Rs2Tu5Vw8Xy1Zb4Ce7Df0Gh3Ik6Jl9Mn2

# URLs (remplacer par votre domaine)
SITE_URL=https://votre-app.com
API_EXTERNAL_URL=https://api.votre-domaine.com
```

### 3. Configurer les domaines

Dans Dokploy, configurez deux domaines:

1. **API Gateway (Kong)**: `api.votre-domaine.com` -> port 8000
2. **Studio Dashboard**: `studio.votre-domaine.com` -> port 3000

### 4. Deployer

Cliquez sur "Deploy" dans Dokploy.

## Configuration Next.js

Utilisez ces variables dans votre application Next.js:

```env
# .env.local
NEXT_PUBLIC_SUPABASE_URL=https://api.votre-domaine.com
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNzMyNDcwNDAwLCJleHAiOjE5ODg3NzA0MDB9.Kx5Nt2Lm8Pq1Rv4Sw7Tz0Wc3Yf6Zh9Bk2Dn5Gj8Jm0

# Pour le serveur uniquement
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJvbGUiOiJzZXJ2aWNlX3JvbGUiLCJpYXQiOjE3MzI0NzA0MDAsImV4cCI6MTk4ODc3MDQwMH0.Xm3Nq6Pj9Rs2Tu5Vw8Xy1Zb4Ce7Df0Gh3Ik6Jl9Mn2
```

## Acces au Dashboard Studio

- URL: `https://studio.votre-domaine.com` ou `http://localhost:3000`
- Username: `supabase`
- Password: `Rt5Yh8Km2Nq6Pw9Sx3Vz1Bc4Df7Gj0Lm`

## Endpoints API

| Service | Endpoint |
|---------|----------|
| REST API | `https://api.votre-domaine.com/rest/v1/` |
| Auth | `https://api.votre-domaine.com/auth/v1/` |
| Storage | `https://api.votre-domaine.com/storage/v1/` |
| Realtime | `wss://api.votre-domaine.com/realtime/v1/` |
| Functions | `https://api.votre-domaine.com/functions/v1/` |

## Generation de nouvelles cles JWT

Pour generer de nouvelles cles JWT securisees, utilisez ce script Node.js:

```javascript
const jwt = require('jsonwebtoken');

const JWT_SECRET = 'VOTRE_JWT_SECRET_32_CARACTERES';

// ANON_KEY
const anonKey = jwt.sign(
  {
    iss: 'supabase',
    role: 'anon',
    iat: Math.floor(Date.now() / 1000),
    exp: Math.floor(Date.now() / 1000) + (10 * 365 * 24 * 60 * 60) // 10 ans
  },
  JWT_SECRET
);

// SERVICE_ROLE_KEY
const serviceRoleKey = jwt.sign(
  {
    iss: 'supabase',
    role: 'service_role',
    iat: Math.floor(Date.now() / 1000),
    exp: Math.floor(Date.now() / 1000) + (10 * 365 * 24 * 60 * 60)
  },
  JWT_SECRET
);

console.log('ANON_KEY:', anonKey);
console.log('SERVICE_ROLE_KEY:', serviceRoleKey);
```

## Securite

**IMPORTANT**: Avant de deployer en production:

1. Changez tous les mots de passe par defaut
2. Generez de nouvelles cles JWT avec votre propre JWT_SECRET
3. Activez HTTPS sur tous les domaines
4. Configurez un SMTP pour les emails de confirmation

## Volumes persistants

Les donnees sont stockees dans ces volumes Docker:
- `supabase-db-data` - Donnees PostgreSQL
- `supabase-storage-data` - Fichiers uploades

## Depannage

### Les services ne demarrent pas

Verifiez que PostgreSQL est healthy avant les autres services:
```bash
docker logs supabase-db
```

### Erreur d'authentification

Verifiez que les cles JWT sont correctement generees avec le meme JWT_SECRET.

### Studio inaccessible

Verifiez les credentials du dashboard et que le service `studio` est bien demarre.