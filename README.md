# EasyStudy

A full-stack React study dashboard using **Firebase** for accounts/data and **Cloudflare Workers + Static Assets** for hosting and server-side API routes.

## Included

- Firebase email/password and Google authentication
- Firestore-backed user profiles
- Week A / Week B timetable with automatic rotation
- Homework / revision task planner
- Topic library across Maths, Biology, Chemistry, Physics, English, Computer Science, History and Geography
- Working practice quizzes with saved results
- Flashcard decks with create/edit/delete, review mode and known/missed counts
- Resource hub with built-in trusted links and user-saved links
- Progress page based on actual completed topics and quiz attempts
- Dark/light theme and responsive mobile layout
- Custom YouTube study player with queue, seek, volume, next/previous and URL import
- Cloudflare Worker YouTube music search endpoint (API key kept server-side)
- Firestore security rules scoped to each signed-in user

## 1. Install and run locally

```bash
npm install
npm run dev
```

The Cloudflare Vite plugin runs the React app and Worker together during development.

## 2. Firebase setup

The project is already connected to:

- Project ID: `easystudy-67e76`
- Auth domain: `easystudy-67e76.firebaseapp.com`

Enable these in the Firebase Console:

1. Authentication → Email/Password
2. Authentication → Google
3. Firestore Database

### Deploy the included Firestore rules

From the project directory:

```bash
npx firebase-tools login
npx firebase-tools deploy --only firestore:rules,firestore:indexes
```

The supplied rules only let an authenticated user read/write documents inside their own `users/{uid}` tree.

> Do not leave Firestore in test mode when the site is public.

## 3. YouTube search for the custom player

**Direct YouTube URL import already works without an API key.**

To enable search inside EasyStudy, create a Google Cloud API key with **YouTube Data API v3** enabled. Then:

### Local development

Copy `.dev.vars.example` to `.dev.vars`:

```text
YOUTUBE_API_KEY=your_key_here
```

Do not commit `.dev.vars`.

### Cloudflare production secret

```bash
npx wrangler secret put YOUTUBE_API_KEY
```

Paste the key when Wrangler asks for it.

The browser calls `/api/youtube/search`; the Worker calls YouTube, so this key is not bundled into the React JavaScript. The search route is limited to embeddable videos in YouTube's Music category and uses strict SafeSearch.

## 4. Deploy to Cloudflare

### Quick deploy from your computer

```bash
npm run deploy
```

Wrangler builds the Vite app and deploys the Worker + static assets together.

### GitHub → Cloudflare automatic deploys

1. Upload this project to a GitHub repository.
2. In Cloudflare, create/import a Workers application from that Git repository.
3. Build command: `npm run build`
4. Deploy command: `npx wrangler deploy`
5. Add the `YOUTUBE_API_KEY` secret in the Cloudflare project settings if you want in-app YouTube search.
6. Add your custom domain in Cloudflare.

After the domain is live, add that exact domain to:

**Firebase Console → Authentication → Settings → Authorized domains**

Otherwise Google sign-in may be rejected on the deployed site.

## 5. Project structure

```text
EasyStudy/
├─ src/
│  ├─ components/       navigation + persistent YouTube player
│  ├─ context/          Firebase auth + music queue state
│  ├─ data/             starter subjects, questions, resources
│  ├─ hooks/            Firestore live collection hook
│  ├─ lib/              Firebase + date helpers
│  ├─ pages/            all working app pages
│  └─ styles/           global, layout, pages and player CSS
├─ worker/
│  └─ index.js          Cloudflare API Worker
├─ firestore.rules
├─ firebase.json
├─ wrangler.jsonc
└─ vite.config.js
```

## Firestore layout

The UI creates data automatically as it is used:

```text
users/{uid}
users/{uid}/tasks/{taskId}
users/{uid}/timetable/{lessonId}
users/{uid}/decks/{deckId}
users/{uid}/decks/{deckId}/cards/{cardId}
users/{uid}/topicProgress/{subject_topic}
users/{uid}/practiceAttempts/{attemptId}
users/{uid}/resources/{resourceId}
users/{uid}/music/{trackId}
```

## Notes about the YouTube player

The custom UI controls the official YouTube embedded player. It does **not** remove or bypass YouTube ads, notices or platform restrictions. The video remains visible while playing; minimising the EasyStudy player pauses playback.

## Next content expansion

The app ships with a starter curriculum dataset so every major feature works immediately. For a genuinely large content library, expand `src/data/subjects.js` / `src/data/questions.js`, or move curated/licensed public content into a separate content database/API. Avoid copying copyrighted textbooks, paid revision-site databases or restricted past-paper content without permission.
