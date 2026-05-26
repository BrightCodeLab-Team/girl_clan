# App Store Review — Girl Clan

Copy the sections below into **App Store Connect → Your App → App Review Information**.

Also set **Sign-in required** and enter the demo username/password in the dedicated fields (not only in Notes).

---

## Demo account (required)

Create this user in **Firebase Console → Authentication** before submitting.


| Field                | Value                                                                                        |
| -------------------- | -------------------------------------------------------------------------------------------- |
| **Username (email)** | `appreview@girlclan.app` *(or your own email — update both Firebase and App Store Connect)*  |
| **Password**         | Choose a strong password (min. 7 characters) and use the **same** value in App Store Connect |


### Firebase setup checklist

1. **Authentication → Add user** with the email and password above.
2. Open the user → **⋮ → Mark email as verified** (required; otherwise the app blocks access after restart).
3. **Firestore → `app-user` → Add document** with Document ID = the user’s UID:

```json
{
  "id": "<USER_UID>",
  "firstName": "App",
  "surName": "Review",
  "email": "appreview@girlclan.app",
  "phoneNumber": "+10000000000",
  "location": "London, UK",
  "country": "United Kingdom",
  "dob": "1990-01-01",
  "nationality": "British",
  "imgUrl": "",
  "interests": ["Social", "Wellness"],
  "termsAccepted": true,
  "termsLastUpdated": "April 2026"
}
```

1. Log in on a physical iPhone with this account and confirm you reach the home screen.

---

## Notes field (paste into App Review Information)

```
DEMO ACCOUNT
Email: appreview@girlclan.app
Password: appreview@123

HOW TO SIGN IN
1. Launch Girl Clan.
2. Tap Login on the welcome screen.
3. Enter the demo email and password above.
4. You will reach the main app (Home, Groups, Chat tabs).

APP PURPOSE & AUDIENCE
Girl Clan is a community app for women to discover local events, join interest-based groups, chat with members, and create their own events and groups. It helps users find social and wellness activities nearby and stay connected with their community.

TEST DEVICES
- iPhone 14 Pro, iOS 18.x
- iPhone 12, iOS 17.x
(Add the real devices and OS versions you used.)

SETUP / MAIN FEATURES (no extra files required)
- Login: demo credentials above.
- Home: browse upcoming and popular events; open event details; join events.
- Groups: browse groups, view details, join or leave groups; hosts can create/delete their groups.
- Create (+ tab): create events or groups (location picker may request location permission).
- Chat: direct and group messaging after joining a group or starting a chat.
- Profile: view/edit profile, interests, notifications, privacy policy, logout, delete account (Profile → Delete Account).

PAID CONTENT / SUBSCRIPTIONS
None. The app is free with no in-app purchases or subscriptions.

USER-GENERATED CONTENT
Users can create events, groups, and chat messages. Users can delete their own chats and groups they host. Account deletion: Profile → Delete Account (permanent). Content reporting/blocking is not implemented in v1; moderation is handled via Firebase/backend if needed.

PERMISSIONS SHOWN IN APP
- Location (when in use): maps for events/groups and location when creating events.
- Camera / Photo Library: profile and event images.
- Push notifications: optional; requested on first use for event/chat alerts.
- No App Tracking Transparency (no cross-app tracking).

EXTERNAL SERVICES
- Firebase Authentication (login/sign-up)
- Cloud Firestore (events, groups, users, chats)
- Firebase Storage (profile images)
- Firebase Cloud Messaging (push notifications)
- Google Maps / Places (maps and place search)
- Branch.io (deep links)
- OpenStreetMap via flutter_map (map tiles)

REGIONAL DIFFERENCES
None. The same features and content are available in all regions where the app is distributed.

REGULATED INDUSTRY / LICENSED CONTENT
Not applicable. The app is a general community/events platform with no regulated medical, financial, or licensed third-party media content.

SCREEN RECORDING
A screen recording on a physical device is attached separately (or uploaded via Resolution Center), showing: app launch → login with demo account → home/events → groups → create flow (optional) → chat → profile → logout.
```

---

## Screen recording (required)

Record on a **physical iPhone** (latest iOS you support), starting from the app icon:

1. Cold launch → Welcome → **Login** with demo account
2. Home: scroll events, open one event
3. Groups tab: open a group
4. Optional: Create tab → start creating an event (show location permission if prompted)
5. Chat tab
6. Profile → Privacy Policy → **Logout**
7. (Optional) Sign up flow or **Profile → Delete Account** on a throwaway test user — do not delete the demo account Apple will use

Upload the video in App Store Connect (Resolution Center reply or App Review attachment, per Apple’s current workflow).

---

## Resubmit checklist

- Demo user exists in Firebase with **email verified**
- Firestore `app-user/{uid}` document exists
- App Store Connect → **Sign-in required** = Yes, with email + password
- **Notes** field filled (text above)
- Screen recording uploaded
- Screenshots show real in-app UI (not only splash/login)
- Test login on a real device before resubmitting

