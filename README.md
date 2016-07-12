# What Is This?

Sirist is a simple iOS app to help add tasks to **Todoist** via **Siri**. 

It automates pushing anything added to iOS **Reminders** up to the **Todoist** API.

# Why?

Adding tasks by **Siri** is the quickest way on iOS to captures ideas on the fly from ones mind and file them away for further action. Unfortunately, **Siri** is limited to only being able to add tasks to the Apple **Reminders** app and **Todoist** does not currently integrate on device with **Reminders**. Sirist helps bridge this gap.

# Project Synopsis

The project uses background fetch updates to wake periodically query the iOS **Reminders** datastore and make background http requests to **Todoist** to transfer **Siri**-added (or **Reminders**.app-added) tasks from **Reminders** to **Todoist** via the **Todoist** API.

# Alternatives & Their Drawbacks

There are existing ways to achieve this but I find the current solutions lacking due to the requirement of either additional services' overhead or required manual interaction by the user.

**IFTTT** — https://ifttt.com/ — The longstanding great services bridge. The 'Recipe' for achieving a **Reminders**->**Todoist** sync is accomplished by similar means to this sample application but with an additional requirement of having a 3rd party account associated with the transfer and a less specific background mode. (Anecdotally, I found this integration to be unreliable)

**Workflow** — https://workflow.is/ — A different approach that occurs on-device. This is nice because it requires no location services, background modes, and no additional HTTP requests to accomplish the migration, but unfortunately the user must take action by opening and running a workflow manually to move tasks along. This can be done easily by creating a shortcut on the homepage that launches **Todoist** after the migration occurs but this then clutters the task switch with Workflow when otherwise you wouldn't have had it open.

# Future Improvements

For this application, I would like to make the following improvements to the current state—

1. Incorporate Scheduling, Repeats, Locations, & Priorities — both iOS Reminders and Todoist tasks have these attributes and it'd be nice to have 1:1 mapping between the two datastores but for the limited scope of this application — importing tasks out of the mind into the Inbox — adding these attributes is best offloaded to the Todoist app for now.

2. Better Debugging of NSURLSession background configuration incorporated. As it stands now, the app relies on a lot of expected behavior but for a fully robust solution it would need to be augmented with better error handling in Debug for each step in the process.

3. Fancier UI & Localized Copy — While the spartan (and borrowed artwork) make for an app that satisfies its limited on screen user interaction, it could always do with more flourish and a copy sanity check.

# Planned Obsoletion

The best case scenario for the user would be for this application to be obsolete by one of two means:

1. **Siri** API allows for adding tasks to alternative applications such as **Todoist**. Currently, the domains allowed for **Siri**Kit does not include tasks — https://developer.apple.com/sirikit/.

2. **Todoist** incorporates this functionality into their iOS application so that the migration occurs within their application on device removing the need for a second helper application.
