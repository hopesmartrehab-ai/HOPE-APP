# HOPE Meeting Notes

---

## Organized Summary

---

### 1. Patient Bottom Navigation Bar
> **Scope:** Flutter only

After clicking **Patient Mode**, the app shows a bottom navigation bar with **3 tabs**:

| Tab | Purpose |
|-----|---------|
| **Home** | Main landing screen with "Welcome to HOPE, Ali" greeting |
| **Progress** | Dashboard showing exercise performance over time |
| **Help** | Support / miscellaneous resources |

The **Start Session** action lives within this navigation structure.

**Questions (answered):**
- What does the **Home** tab actually show beyond the welcome message? **Yes — it's the session launcher. The entire existing session flow (assessment → questionnaire → exercise) lives here.**
- What goes inside **Help**? **Use the medical illustration images from `assets/questionnaire/` (sleep, blood pressure, dizzy, arm pain, falls, hand movement, blood sugar, fatigue, temperature, headache). Also look for a "dd" txt file for content guidance.**
  - **Note:** No DD txt file was found in the project. Need to ask where it is or if it still needs to be added.
- Does the patient ever see anything *before* the bottom nav appears? **No — the flow before the Patient/Doctor role selection stays the same. Just add a snackbar "Welcome, Ali" when entering Patient Mode. Bottom nav appears after role selection.**

<details>
<summary><strong>AI Prompt</strong></summary>

```
In the HOPE Flutter app, after tapping "Patient Mode" on the role selection screen, wrap the patient experience in a persistent bottom navigation bar with 3 tabs: Home, Progress, and Help. Also show a brief snackbar greeting "Welcome, Ali" on entry.

**Home tab (default):**
- This is the existing session start screen (`session_start_screen.dart`). The full session flow (assessment → questionnaire → exercise) launches from here.
- Do NOT rebuild the session flow — just embed the existing SessionStartScreen as the Home tab content.

**Progress tab:**
- Show the existing `DashboardScreen` (from `lib/screens/dashboard/dashboard_screen.dart`) in `DashboardMode.patient` mode. It already displays per-category score charts for Reach, Grasp, Manipulation, and Release.

**Help tab:**
- Build a scrollable help/info screen using the 10 medical illustration images already in `assets/questionnaire/`:
  sleep.jpeg, blood_pressure.jpeg, dizzy.jpeg, arm_pain.jpeg, falls.jpeg, hand_movement.jpeg, blood_sugar.jpeg, fatigue.jpeg, temperature.jpeg, headache.jpeg
- Display each image as a card with its topic name as a label (e.g., "Sleep", "Blood Pressure", "Dizziness", etc.).
- Use common sense to make it a useful health reference page — brief descriptions of each health indicator and why the app tracks it.

**Snackbar:** When the patient lands on this screen, show a brief SnackBar: "Welcome, Ali 👋" that auto-dismisses after 3 seconds.

**Navigation:** The session flow (Start Session → Assessment → Questionnaire → Exercise) pushes on top of the nav bar (navigator push), not inside it. Pressing back from the session returns to the Home tab with the nav bar intact.

**Expected outcome:** After "Patient Mode", Ali sees a bottom nav (Home selected), a snackbar greeting, and can start sessions from Home, check progress in Progress, or browse health info in Help. The existing session flow is untouched — only the entry point changes.

**Do not** modify the role selection screen, welcome screen, or any screen inside the session flow itself.
```

</details>

---

### 2. Doctor Bottom Navigation Bar
> **Scope:** Flutter only

The Doctor view gets its own bottom nav with **2 tabs**: the existing patient/session list, and the existing dashboard.

The Doctor dashboard **already exists** (`lib/screens/dashboard/dashboard_screen.dart` in `DashboardMode.practitioner`) — it just needs to be wired into the bottom nav bar instead of being accessed via an icon button.

**Questions (answered):**
- What are the 2 Doctor tabs? **Tab 1 = the existing session list screen (`session_list_screen.dart`). Tab 2 = the existing dashboard screen.**
- Is it aggregated or per-patient? **Single patient (Ali), single doctor (Kenzy) — this is a demo.**

<details>
<summary><strong>AI Prompt</strong></summary>

```
In the HOPE Flutter app, after tapping "Doctor Mode" on the role selection screen, wrap the doctor experience in a bottom navigation bar with 2 tabs.

**Tab 1 — Sessions (default):**
- Show the existing `SessionListScreen` (`lib/screens/practitioner/session_list_screen.dart`). This already lists Ali's sessions and lets the doctor drill into session details and exercise results.
- Do NOT rebuild this screen — embed it as-is.

**Tab 2 — Dashboard:**
- Show the existing `DashboardScreen` (`lib/screens/dashboard/dashboard_screen.dart`) in `DashboardMode.practitioner` mode. It already shows per-category score charts for Reach, Grasp, Manipulation, and Release across sessions.
- Remove the current dashboard icon/button from the session list screen's app bar since it's now a dedicated tab.

**Expected outcome:** After "Doctor Mode", Dr. Kenzy lands on the Sessions tab with a 2-tab bottom nav. Tapping Dashboard shows the existing practitioner dashboard. Tapping into a session from the Sessions tab pushes the detail view on top of the nav bar. Back returns to the Sessions tab.

**Do not** create placeholder screens — both tabs already have fully built screens. This is purely a navigation restructure.
```

</details>

---

### 3. Doctor Sees Patient-Recorded Videos
> **Scope:** Flutter only (+ backend for video retrieval)

Inside the Doctor's session detail view, if the patient recorded a video of themselves during a session (exercise or assessment), the Doctor can view it. View only — no annotations. If no video exists, nothing is shown. The patient should also be able to record during assessment (not just exercises).

**Questions (answered):**
- Does the Doctor see one video per exercise, or one video per entire session? **Whichever is easiest. Currently, video is stored per-session as `session.videoUrl` (one video per session, not per exercise). Easiest path: show the session video in the session detail.**
- Can the Doctor do anything with the video? **No — view only.**
- Is this the same video the patient records today? **Yes, the same one from `video_recorder_widget.dart` during the exercise waiting screen. Patient should also be able to record during assessment (new addition).**

<details>
<summary><strong>AI Prompt</strong></summary>

```
In the HOPE Flutter app's Doctor view, make the patient's self-recorded video visible in the session detail screen and exercise results.

**Current state:**
- The patient records one video per session using `VideoRecorderWidget` during the exercise waiting screen.
- The video is uploaded to S3 and the URL is stored as `session.videoUrl`.
- The Doctor's session detail screen (`session_detail_screen.dart`) already has a `_InfoTab` that checks for `session.videoUrl` (lines ~233-240) and shows a `VideoPlayerWidget`.

**Changes needed:**
1. **Verify the existing video display works:** The doctor's session detail screen already has video player code. Ensure it renders correctly — if `session.videoUrl` is non-null, show the video player prominently (not buried). If null, show nothing (no empty state).

2. **Add video recording to the assessment flow:** Currently the patient can only record during exercises. Add the same `VideoRecorderWidget` to the assessment waiting screen (`assess_waiting_screen.dart`) so the patient can also film themselves during assessment. Store this as a separate field (e.g., `session.assessmentVideoUrl`) or reuse the same `videoUrl` field if the backend only supports one video per session.

3. **Doctor exercise view:** In the exercises tab / exercise results shown to the doctor, if a session video exists, show a play button that opens the video in the existing fullscreen `ExerciseVideoPlayer` modal. View only — no annotations, no comments.

**Expected outcome:** Dr. Kenzy opens Ali's session and can see/play the video Ali recorded. If Ali recorded during assessment, that video is also viewable. No video = no placeholder, just clean UI.

**Do not** create a new upload mechanism — reuse the existing S3 pre-signed URL flow from `SessionProvider`.
```

</details>

---

### 4. Exercises Must Reflect Assessment Results
> **Scope:** Flutter + Backend

The exercises assigned to the patient should directly correspond to what they **failed (or succeeded at)** during the assessment. Currently only "Reach" is shown — but it should cover all assessed categories. The patient should do as many exercises as they failed in the assessment.

**Questions (answered):**
- How many categories? **Exactly 4: Reach, Grasp, Manipulation, Release** (defined in `dashboard_screen.dart` line 16 as `const _categories = ['Reach', 'Grasp', 'Manipulation', 'Release']`).
- How many exercises per failed category? **One exercise per failed category. If you fail 3, you do 3 exercises.**
- What about passed categories? **Whatever's easiest — hide them or show as completed.**
- What's the current bug? **The app only makes the patient do the Reach exercise and only shows Reach results, regardless of assessment outcome. The exercise flow is hardcoded to Reach somewhere.**

<details>
<summary><strong>AI Prompt</strong></summary>

```
In the HOPE Flutter app, fix the exercise flow so the patient does exercises for ALL failed assessment categories, not just Reach.

**The bug:** After the assessment, the app always sends the patient to do only the Reach exercise and shows only Reach results — even if the patient failed Grasp, Manipulation, or Release too. The exercise flow is hardcoded to Reach somewhere in the pipeline.

**The 4 assessment categories are:** Reach, Grasp, Manipulation, Release
(defined as `const _categories = ['Reach', 'Grasp', 'Manipulation', 'Release']` in `dashboard_screen.dart`)

**How to fix:**
1. **Find the hardcoding:** Trace the flow from `AssessmentResultsScreen` → `ExerciseWaitingScreen` → `ExerciseResultsScreen`. Somewhere in this pipeline, the exercise type is hardcoded to "Reach" instead of being driven by the assessment results. Check the session provider, the API calls, and the exercise waiting screen for where the category is set.

2. **Make it dynamic:** After assessment completes, read which categories the patient failed. For each failed category, the patient should perform the corresponding exercise. The exercise waiting screen should cycle through all failed categories (it already has a carousel/paging mechanism for tutorial videos — extend this to handle multiple exercises).

3. **Show results for all:** The exercise results screen should display scores for every exercise performed, not just Reach.

4. **Passed categories:** Show them as completed/greyed out or simply hide them — whichever requires less code.

5. **Inspect cloud data:** Check the DynamoDB sessions table (eu-west-3, table name in the backend config) to see if previous sessions have data for all 4 categories or only Reach. This will confirm whether the bug is frontend-only or also in the backend/firmware.

**Expected outcome:** Ali takes an assessment, fails Reach and Release, passes Grasp and Manipulation. The exercise flow then has Ali do 2 exercises: Reach and Release. Results show scores for both. The dashboard later reflects all 4 categories with the new data.

**This is a fundamental bug fix** — the current app is essentially only exercising 1 out of 4 possible categories.
```

</details>

---

### 5. Assessment + Exercise Tutorial Videos
> **Scope:** Flutter only

Both the assessment flow AND the exercise flow will have YouTube tutorial videos. Assessment videos play automatically before each task. Exercise videos are already partially implemented — URLs need updating.

**Questions (answered):**
- Does each assessment step get its own video, or is there one overview video? **Videos show for BOTH assessment AND exercises. Currently only exercises have tutorial videos — assessment needs them too.**
- Do these play automatically? **Yes, automatically before each task.**
- Are these the same videos as the exercise waiting screen? **No — there are separate assessment-specific videos and exercise-specific videos. See video list below.**

**YouTube Video List (titles fetched):**

| # | URL | Title | Likely Category |
|---|-----|-------|----------------|
| 1 | https://youtu.be/rLHncdGS_LM | ass reach | Assessment — Reach |
| 2 | https://youtu.be/3fJjUZVAReE | ass grasp1 | Assessment — Grasp |
| 3 | https://youtu.be/Mcn7dQChtRU | ass manipulation | Assessment — Manipulation |
| 4 | https://youtu.be/gryKpTOupaI | open and close release | Assessment — Release |
| 5 | https://youtu.be/X6xknjTL9Pk | reach | Exercise — Reach |
| 6 | https://youtu.be/dOQYnjgu_lE | reach2 | Exercise — Reach (alt) |
| 7 | https://youtu.be/wosfBtRSGv8 | grasp | Exercise — Grasp |
| 8 | https://youtu.be/DQ0Wm5w7WY0 | Pinch Grasp | Exercise — Grasp (pinch) |
| 9 | https://youtu.be/gMoJyBPYIWw | Cylindrical Grasp | Exercise — Grasp (cylindrical) |
| 10 | https://youtu.be/4MB7xaQmO-I | Controlled Release | Exercise — Release |
| 11 | https://youtu.be/sXkI2tPIOn0 | bimanual open jar | Exercise — Manipulation |

**Remaining question:** Some categories have multiple exercise videos (e.g., Grasp has "grasp", "Pinch Grasp", "Cylindrical Grasp"). Should the patient see all of them as a playlist, or just one per category?

<details>
<summary><strong>AI Prompt</strong></summary>

```
In the HOPE Flutter app, add YouTube tutorial videos to BOTH the assessment flow and the exercise flow. Currently only exercises have tutorial videos — assessment needs them too.

**Assessment tutorial videos (play automatically before each assessment task):**
- Reach: https://youtu.be/rLHncdGS_LM ("ass reach")
- Grasp: https://youtu.be/3fJjUZVAReE ("ass grasp")
- Manipulation: https://youtu.be/Mcn7dQChtRU ("ass manipulation")
- Release: https://youtu.be/gryKpTOupaI ("open and close release")

**Exercise tutorial videos (play during the exercise waiting screen):**
- Reach: https://youtu.be/X6xknjTL9Pk ("reach"), https://youtu.be/dOQYnjgu_lE ("reach2")
- Grasp: https://youtu.be/wosfBtRSGv8 ("grasp"), https://youtu.be/DQ0Wm5w7WY0 ("Pinch Grasp"), https://youtu.be/gMoJyBPYIWw ("Cylindrical Grasp")
- Release: https://youtu.be/4MB7xaQmO-I ("Controlled Release")
- Manipulation: https://youtu.be/sXkI2tPIOn0 ("bimanual open jar")

**Assessment flow changes:**
1. In the assessment waiting screen (`assess_waiting_screen.dart`), before each assessment category begins, automatically play the corresponding YouTube tutorial video.
2. After the video finishes (or user taps "Continue"/"Skip"), proceed to the actual assessment task for that category.
3. This repeats for each of the 4 categories: Reach → Grasp → Manipulation → Release.

**Exercise flow changes:**
1. The exercise waiting screen (`exercise_waiting_screen.dart`) already has a video carousel. Update the video URLs to use the exercise-specific videos listed above.
2. For categories with multiple videos (e.g., Grasp has 3), show them all in the carousel for that exercise.
3. Existing exercise video config is in `lib/services/exercise_videos.dart` — update the URLs there.

**Video playback:** Use the existing `ExerciseVideoPlayer` widget or YouTube iframe player. Videos play automatically when the screen appears. Patient can skip via a "Continue" button.

**Expected outcome:** Ali starts assessment — before the Reach assessment, a video plays showing what to do. After watching (or skipping), the Reach assessment begins. Same for Grasp, Manipulation, Release. Then during exercises, each exercise shows its relevant tutorial videos.

**Store all video URLs in a single config map** (e.g., in `exercise_videos.dart` or a new `tutorial_videos.dart`) so they're easy to update.
```

</details>

---

### 6. Hardcoded User Names
> **Scope:** Flutter only

For now:
- **Patient name** = "Ali"
- **Doctor name** = "Kenzy"

**Questions (answered):**
- Where do names appear? **Primarily in greetings. Can also appear in labels where it makes sense — use best judgment.**
- Will they come from a login system later? **No — hardcoded for the demo, permanently.**

<details>
<summary><strong>AI Prompt</strong></summary>

```
In the HOPE Flutter app, hardcode the patient name as "Ali" and the doctor name as "Kenzy" and use them in greetings and labels throughout the app.

**Where to apply:**
- Patient snackbar on entry: "Welcome, Ali"
- Patient Home tab header: "Welcome to HOPE, Ali"
- Doctor dashboard header: update the existing greeting in `DashboardScreen` (practitioner mode) to say "Dr. Kenzy's Dashboard" or "Welcome, Dr. Kenzy"
- Doctor session list: can show "Ali's Sessions" or "Patient: Ali" as a header if it fits naturally
- Session detail screen: where patient info is shown, use "Ali" instead of any generic placeholder

**Implementation:** Store as named constants in a single place (e.g., `lib/constants/demo_users.dart`):
  - `const kPatientName = 'Ali';`
  - `const kDoctorName = 'Kenzy';`
Reference these constants everywhere instead of hardcoding strings in each screen.

**Expected outcome:** The app feels personalized — Ali sees his name, Dr. Kenzy sees hers. No login, no profile system. These are permanent demo constants.

**Do not** add a login screen, user selection, or any dynamic name resolution. This is strictly hardcoded.
```

</details>

---

## Raw Notes (Original / Verbatim)

- (the user flow (post-clicking patient mode) is going to have 3 tabs in the bottom navigation bar, (Home, Dashboard, and help),


| Column1 | Column2 | Column3 |
| --------------- | --------------- | --------------- |
| HELP    | miscellenious vectors  | Item3.1 |
| Item1.2 | Item2.2 | Item3.2 |
| Item1.2 | Item2.2 | Item3.2 |


 tabs in the bottom ) START SESSION > Add bottom navigation bar 

- BOTTOM NAV BAR >> (HOME, Progress (dashboard), Help)

- DR will have dashboard as well, DR is going to have 2 tabs in the bottom navigation bar, 

- DR is going to have the video the user he or she filmed of themselves visible (if non null) inside the exercises tab

- the number and type of exercises should reflect what the user has failed (or succeeded) from the assessment (now it only shows reach, then the reach exercise results, this is fundamental) I should do as many exercises as I failed them in the assessment

- The assessment is going to have videos too, (YT, link will be provided at a later date)

- Add welcome to HOPE patient name should be assumed "ALI"
- DR name should be assumed "Kenzy"
