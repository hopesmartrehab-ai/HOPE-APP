# HOPE Project — Clarifying Questions (ANSWERED)

This file is the canonical record of decisions for finishing the HOPE project. The deep-dive agents (Flutter × 2, backend × 2, firmware × 2, plus 5–6 live-test probes against the prod API) returned with findings; the user has now answered every question. Each question is followed by an **A:** line capturing the decision.

---

## A. Project framing & goals

**A1. What does "demo" mean concretely?**
**A:** Functional, single-user demo. The user opens the app at home (their own WiFi), taps "Patient" on the welcome screen (no login), runs the full session flow (assessment → questionnaire → exercise) end-to-end, optionally films themselves doing the exercise. Practitioner mode shows a log of all sessions, including the recorded video for sessions that have one.

**A2. Who is the audience for the demo?**
**A:** The user and a friend.

**A3. What's the deadline?**
**A:** ASAP.

**A4. Single user or many?**
**A:** Single user, single practitioner. No authentication. No identity model.

**A5. Is the project intended to ever leave demo state?**
**A:** No.

---

## B. Clinical / functionality scope

**B6. Are the assessment thresholds clinically meaningful or placeholder?**
**A:** Don't worry about the thresholds. Leave them.

**B7. Should the session walk through all failed categories or only `needed_training[0]`?**
**A:** Leave as-is. The behavior is determined by the existing Python script in the cloud.

**B8. Is the 10-field questionnaire schema final?**
**A:** Yes, locked.

**B9. Questionnaire AFTER assessment, BEFORE exercise — correct?**
**A:** Yes. Flutter app flow is the canonical order.

**B10. Skip-questionnaire behavior?**
**A:** Allow skip. Record "skipped" so the practitioner sees it. Practitioner is told "no big deal."

**B11. Practitioner mode — anything beyond read-only?**
**A:** Read-only viewer. Lists all sessions; opens a session to see details + the recorded video (if one exists). No annotation, no reports, no goals.

**B11a. Practitioner UX bugs (status badges + raw questionnaire keys)?**
**A:** Fix both. Map the real backend statuses to badges. Localize questionnaire keys to human labels (EN + AR).

**B11b. Sessions have no patient identity. Confirming OK?**
**A:** Confirmed. Single user.

**B12. Video upload — finish, tear out, or leave dormant?**
**A:** Finish wiring it up. The S3 region issue is already resolved by the eu-west-3 migration. Add a UI to record and upload. **Reduce video quality to ~480p** (especially on iPhone / modern devices) so uploads don't take forever.

**B13. Auth/login?**
**A:** No auth. Single user, single practitioner — assumed.

---

## C. Hardware (ESP32 glove)

**C14. Is the glove physical hardware fully built and working?**
**A:** Yes, fully built and working.

**C15. Hardcoded WiFi credentials — intentional?**
**A:** Yes, intentional.

**C16. Device ID hardcoded to `hope-glove-01` — fine?**
**A:** Yes. Furthermore: **remove the device_id picker from the app**. Hardcode it on the app side too so it always matches the firmware. Single glove, single app.

**C17. No local buffering on WiFi drop — acceptable?**
**A:** Acceptable for demo.

**C18. 100 samples × 50ms batches — fine?**
**A:** Leave as-is.

**C19. Onboard LED status indicator?**
**A:** No. Leave it without an indicator.

**C20. Calibration UI?**
**A:** No. Hardcoded values are fine.

---

## D. Backend issues

**D21. `GET /sessions` 502 from missing `created_at` in two garbage rows.**
**A:** Fix it. Both the one-line code fix (`s.get('created_at', '')`) and clean the bad rows. (Note: post-migration to eu-west-3, the table is fresh and empty — but apply the defensive `.get` anyway so it can't recur.)

**D21b. `GET /sessions` no pagination, silently truncates at 1 MB.**
**A:** Accept as-is.

**D22. `/ingest` zero input validation.**
**A:** Both ends are well-behaved so it shouldn't happen in practice. Add validation only if it's not a big deal.

**D23. `/sessions/{any-string}/device` returns 200 even if session doesn't exist.**
**A:** Add a session-existence check. Also: the app must be **fully fault-tolerant** — if the user kills the app mid-session and reopens, the system should reset and let them start fresh. Don't soft-fail on stale state.

**D24. Same device_id linked to two active sessions silently orphans the older one.**
**A:** Should work every single time. Orphan the old one — that's correct behavior here.

**D25. Response shape mismatch between `/ingest` and `GET /sessions/{id}`.**
**A:** Normalize the shapes.

**D26. `POST /sessions` returns 201. Just flagging.**
**A:** No action.

**D27. No DELETE / archive endpoint.**
**A:** Add a delete-session button (backend endpoint + Flutter UI in practitioner mode).

**D28. `POST /sessions` with non-empty non-JSON body crashes (502).**
**A:** Fix it.

**D29. No CORS on OPTIONS preflight; Flutter web build in scope?**
**A:** Mobile only. Drop macOS, Windows, Linux, web targets. Keep iOS + Android.

---

## E. Infrastructure & deployment

**E30. S3 region mismatch.**
**A:** Resolved — full migration to eu-west-3 is done.

**E31. Why was anything in us-east-1?**
**A:** N/A — everything is in eu-west-3 now.

**E32. Bash deploy scripts vs Terraform/CDK?**
**A:** Leave the scripts (scope: easy fixes only — anything bigger is acceptable as-is and shouldn't be "improved" since it costs more).

**E33. CloudWatch dashboard?**
**A:** Acceptable as-is.

**E34. Log retention?**
**A:** Acceptable as-is.

**E35. Custom domain for stable API URL?**
**A:** Acceptable as-is.

---

## F. Flutter app — UX

**F36. Recover session after force-close?**
**A:** No persistence. If the user kills mid-session, the next launch returns to welcome and the in-flight session is orphaned. That's the desired behavior.

**F37. Practitioner session list pagination/filtering?**
**A:** No pagination. No date-range filtering. Acceptable as-is.

**F38. Practitioner session delete?**
**A:** Yes — see D27.

**F39. 3-minute polling timeout — too long?**
**A:** Yes, shorten it.

**F40. Polling every 3s — change to faster?**
**A:** Yes, worth changing.

**F41. Final session-summary screen?**
**A:** No. Don't add a final summary.

**F42. Arabic localization — actually maintained?**
**A:** Yes, Arabic is important. Keep it complete and audit for missing keys.

**F43. Debug overlay (4-right + 3-left taps in 3s) — intentional?**
**A:** Intentional. Document it for the user, but **do not expose in the UI** — keep it as a hidden gesture.

**F44. "Simulate Glove" button visibility?**
**A:** Visible at all times. (Useful even during the demo if the glove misbehaves.)

**F45. Better offline UI?**
**A:** Yes. Show "you don't have internet" instead of generic "Failed to ...".

**F46. Redo-assessment button?**
**A:** Yes, add one.

---

## G. Firmware

**G47. Power-cycle between sessions?**
**A:** Acceptable as-is for single-user demo. No stop-sending signal needed.

**G48. Sensor set correct?**
**A:** Acceptable as-is.

**G49. Calibration rest pose?**
**A:** No calibration. The hardcoded values are good.

**G50. MPU6050 WHO_AM_I disabled?**
**A:** Acceptable as-is.

---

## H. Recommendations — sign-off

**H51. Delete bad-shape session rows that broke `GET /sessions`.**
**A:** Resolved by the eu-west-3 migration (DynamoDB was wiped). Apply the defensive `.get('created_at', '')` so this class of bug can't return.

**H52. Pydantic-style schema validator at Lambda entry points.**
**A:** Add only if cheap. Both ends are well-behaved so the validator is nice-to-have, not load-bearing.

**H53. Single canonical PROJECT.md doc.**
**A:** (No explicit answer in this round — proceeding with the single-doc plan, write the doc last so it captures the actual final state.)

**H54. Plan: (1) bug fixes, (2) video upload, (3) practitioner mode lockdown, (4) final-summary screen, (5) single doc, (6) demo checklist.**
**A:** Drop (4) "final summary screen" — not wanted. Everything else stands.

---

## I. Things intentionally NOT being touched

Confirmed acceptable as-is: file structure, tests, talker/AppLogger, localization machinery, SessionProvider state machine, two-Lambda split, pay-per-request DynamoDB, status field design.

---

## J. Free space

(Nothing additional from user this round.)
