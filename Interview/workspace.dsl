/*
 * Structurizr DSL workspace for "AllDone" (AllDoneCompleteCourse)
 *
 * A SwiftUI + Firebase to-do application built with an MVVM + Store
 * architecture and FactoryKit dependency injection.
 *
 * Render with:  structurizr-cli export -workspace workspace.dsl -format plantuml
 *          or:  docker run -it --rm -p 8080:8080 -v $PWD:/usr/local/structurizr structurizr/lite
 */
workspace "AllDone" "C4 model for the AllDone iOS task-management app (AllDoneCompleteCourse)." {

    !identifiers hierarchical

    model {

        // ---------------------------------------------------------------
        // People
        // ---------------------------------------------------------------
        user = person "App User" "Someone who organises their life with to-do lists and tasks on iPhone or iPad." "Person"

        // ---------------------------------------------------------------
        // The system in scope
        // ---------------------------------------------------------------
        allDone = softwareSystem "AllDone" "iOS application for managing to-do lists and tasks, with e-mail/password accounts and real-time sync across devices." "Internal System" {

            iosApp = container "AllDone iOS App" "Single SwiftUI application target. Presents the UI, holds all client-side state, and talks directly to Firebase. Layered as View -> ViewModel -> Store -> Firebase." "Swift 6, SwiftUI, Combine, FactoryKit" "Mobile App" {

                // ---------- Composition root / infrastructure ----------
                appEntryPoint = component "AllDoneCompleteCourseApp" "@main App scene. Installs AppDelegate and shows AppStartingView in a WindowGroup." "SwiftUI App" "Presentation"
                appDelegate = component "AppDelegate" "UIApplicationDelegate that calls FirebaseApp.configure() at launch." "UIKit / FirebaseCore" "Infrastructure"
                diContainer = component "DI Container" "Container+Registration. Declares singleton Factory registrations for AppInfoStore, AuthStore, UserStore and TodoStore, resolved by @Injected." "FactoryKit" "Infrastructure"

                // ---------- Presentation: views ----------
                appStartingView = component "AppStartingView" "Root view. Switches between the auth flow and the app flow based on AppState." "SwiftUI View" "Presentation"
                authView = component "AuthView" "Sign-in / sign-up / forgot-password screen." "SwiftUI View" "Presentation"
                tasksView = component "TasksView" "Main screen. Shows the to-do lists carousel, the task list, search, and the new-entry FAB." "SwiftUI View" "Presentation"
                settingsView = component "SettingsView" "Profile and app-information sheet, including sign-out." "SwiftUI View" "Presentation"
                sharedComponents = component "Shared UI Components" "AlertView, ErrorView, NewTodoView, NewTodoListView, TaskCompactView, TodoListNameView." "SwiftUI Views" "Presentation"
                viewExtensions = component "View Modifiers & Extensions" "Reusable modifiers: showAlert, showError, showModal, plusFab, loadingRedacted, hideKeyboard, styling helpers." "SwiftUI ViewModifier" "Presentation"

                // ---------- Presentation: view models ----------
                appStartingViewModel = component "AppStartingViewModel" "Derives AppState from the authenticated user and subscribes to authUpdatePublisher." "@MainActor ObservableObject" "ViewModel"
                authViewModel = component "AuthViewModel" "Validates credentials, orchestrates sign-in/sign-up/reset, creates the user profile and the default lists." "@MainActor ObservableObject" "ViewModel"
                tasksViewModel = component "TasksViewModel" "Owns list/task state. Loads lists, subscribes to real-time publishers, filters and sorts tasks, and handles add/delete/complete." "@MainActor ObservableObject" "ViewModel"
                settingsViewModel = component "SettingsViewModel" "Loads the user profile, exposes user/app info rows, and confirms sign-out." "@MainActor ObservableObject" "ViewModel"

                // ---------- Domain ----------
                domainModels = component "Domain Models" "AppUser, TodoList (+ DefaultTodoList), TodoTask, AuthData, AuthType, AppState, AppAlert, InfoData. Codable value types mapped to Firestore documents." "Swift structs / enums" "Domain"
                domainErrors = component "Error Types" "AppError, AuthError, DatabaseError and Error+asAppError, mapping Firebase errors to user-facing messages." "Swift enums" "Domain"
                displayProtocols = component "Alert & Error Protocols" "AlertDisplayable and ErrorDisplayable, adopted by view models; Task+handlingError routes thrown errors into them." "Swift protocols" "Domain"

                // ---------- Data access: stores ----------
                storeProtocols = component "Store Protocols" "AuthStoreProtocol, UserStoreProtocol, TodoStoreProtocol. The abstraction view models depend on." "Swift protocols" "Data"
                authStore = component "AuthStore" "Wraps Firebase Auth: sign in, sign up, reset password, sign out, current user, and an authUpdate publisher." "@MainActor final class" "Data"
                userStore = component "UserStore" "Reads and writes the 'users' collection (AppUser profile documents)." "@MainActor final class" "Data"
                todoStore = component "TodoStore" "Reads and writes 'todo_Lists' and its 'tasks' sub-collection; manages snapshot listeners and seeds the default lists." "@MainActor final class" "Data"
                appInfoStore = component "AppInfoStore" "Static app metadata: name, description, developer, version and minimum OS from the bundle." "final class" "Data"
                firestoreHelpers = component "Firestore Query Helpers" "Query+FirestoreHelpers: generic getDocuments(as:) and addSnapshotListener(as:) that bridge Firestore into Combine publishers." "Swift extension, Combine" "Data"
                mockStores = component "Mock Stores" "MockAuthStore, MockUserStore, MockTodoStore plus View+injectMockData, used by SwiftUI previews." "Swift classes" "Test Double"
            }
        }

        // ---------------------------------------------------------------
        // External systems
        // ---------------------------------------------------------------
        firebase = softwareSystem "Firebase" "Google's mobile backend-as-a-service. Provides identity and the document database for AllDone." "External System" {

            firebaseAuth = container "Firebase Authentication" "Stores user credentials and issues ID tokens. Handles e-mail/password sign-up, sign-in and password-reset e-mails." "Firebase Auth" "External Container"
            firestore = container "Cloud Firestore" "NoSQL document database holding the 'users' collection and the 'todo_Lists' collection with its 'tasks' sub-collection. Pushes real-time snapshot updates." "Cloud Firestore" "Database"
            analytics = container "Firebase Analytics" "Collects anonymous usage and app-measurement events (GoogleAppMeasurement)." "Google Analytics for Firebase" "External Container"
        }

        appStore = softwareSystem "Apple App Store" "Distributes and updates the AllDone application." "External System"

        // ---------------------------------------------------------------
        // Relationships: system context
        // ---------------------------------------------------------------
        user -> allDone "Creates accounts, organises to-do lists and completes tasks"
        user -> appStore "Installs and updates the app from"
        appStore -> user "Delivers the AllDone app to"
        allDone -> firebase "Authenticates users and stores lists and tasks in" "HTTPS / gRPC"

        // ---------------------------------------------------------------
        // Relationships: containers
        // ---------------------------------------------------------------
        user -> allDone.iosApp "Views lists and tasks, and adds, completes or deletes them" "Touch / SwiftUI"
        allDone.iosApp -> firebase.firebaseAuth "Signs users up and in, resets passwords and signs out" "Firebase Auth SDK / HTTPS"
        allDone.iosApp -> firebase.firestore "Reads and writes user profiles, lists and tasks, and subscribes to snapshot updates" "Firestore SDK / gRPC"
        allDone.iosApp -> firebase.analytics "Reports app-measurement events" "Firebase SDK / HTTPS"

        // ---------------------------------------------------------------
        // Relationships: components — bootstrap
        // ---------------------------------------------------------------
        allDone.iosApp.appEntryPoint -> allDone.iosApp.appDelegate "Installs via @UIApplicationDelegateAdaptor"
        allDone.iosApp.appEntryPoint -> allDone.iosApp.appStartingView "Presents in a WindowGroup"
        allDone.iosApp.appDelegate -> firebase "Configures the Firebase SDKs at launch" "FirebaseApp.configure()"
        allDone.iosApp.diContainer -> allDone.iosApp.authStore "Registers as a singleton"
        allDone.iosApp.diContainer -> allDone.iosApp.userStore "Registers as a singleton"
        allDone.iosApp.diContainer -> allDone.iosApp.todoStore "Registers as a singleton"
        allDone.iosApp.diContainer -> allDone.iosApp.appInfoStore "Registers as a singleton"
        allDone.iosApp.mockStores -> allDone.iosApp.storeProtocols "Provides preview implementations of"

        // ---------------------------------------------------------------
        // Relationships: components — user entry points
        // ---------------------------------------------------------------
        user -> allDone.iosApp.authView "Enters credentials into"
        user -> allDone.iosApp.tasksView "Browses lists, searches and completes tasks in"
        user -> allDone.iosApp.settingsView "Reviews their profile and signs out from"

        // ---------------------------------------------------------------
        // Relationships: components — view to view model
        // ---------------------------------------------------------------
        allDone.iosApp.appStartingView -> allDone.iosApp.appStartingViewModel "Observes appState from"
        allDone.iosApp.appStartingView -> allDone.iosApp.authView "Shows when AppState is .auth"
        allDone.iosApp.appStartingView -> allDone.iosApp.tasksView "Shows in a NavigationStack when AppState is .app"

        allDone.iosApp.authView -> allDone.iosApp.authViewModel "Binds fields to and calls authenticate() / resetPassword() on"
        allDone.iosApp.tasksView -> allDone.iosApp.tasksViewModel "Binds state to and calls addTask / addTodoList / deleteTodoList / completeTask on"
        allDone.iosApp.tasksView -> allDone.iosApp.settingsView "Presents as a sheet"
        allDone.iosApp.settingsView -> allDone.iosApp.settingsViewModel "Reads profile and app info from"

        allDone.iosApp.tasksView -> allDone.iosApp.sharedComponents "Composes NewTodoView, NewTodoListView, TaskCompactView and TodoListNameView"
        allDone.iosApp.authView -> allDone.iosApp.viewExtensions "Applies text-field, alert and error modifiers from"
        allDone.iosApp.tasksView -> allDone.iosApp.viewExtensions "Applies FAB, loading-redaction, alert and error modifiers from"
        allDone.iosApp.settingsView -> allDone.iosApp.viewExtensions "Applies alert and error modifiers from"
        allDone.iosApp.sharedComponents -> allDone.iosApp.domainModels "Renders TodoList, TodoTask, AppAlert and InfoData values"

        // ---------------------------------------------------------------
        // Relationships: components — view model to store
        // ---------------------------------------------------------------
        allDone.iosApp.appStartingViewModel -> allDone.iosApp.authStore "@Injected; reads the current user and subscribes to authUpdatePublisher" "Combine"
        allDone.iosApp.authViewModel -> allDone.iosApp.authStore "@Injected; signs users up, in and resets passwords via"
        allDone.iosApp.authViewModel -> allDone.iosApp.userStore "@Injected; creates the AppUser profile via"
        allDone.iosApp.authViewModel -> allDone.iosApp.todoStore "@Injected; seeds the default to-do lists via"
        allDone.iosApp.tasksViewModel -> allDone.iosApp.authStore "@Injected; reads the authenticated user id from"
        allDone.iosApp.tasksViewModel -> allDone.iosApp.todoStore "@Injected; loads lists, subscribes to publishers and mutates lists and tasks via" "Combine"
        allDone.iosApp.tasksViewModel -> allDone.iosApp.appInfoStore "@Injected; reads the app name from"
        allDone.iosApp.settingsViewModel -> allDone.iosApp.authStore "@Injected; signs the user out via"
        allDone.iosApp.settingsViewModel -> allDone.iosApp.userStore "@Injected; loads the AppUser profile via"
        allDone.iosApp.settingsViewModel -> allDone.iosApp.appInfoStore "@Injected; reads version, compatibility and developer from"

        allDone.iosApp.authViewModel -> allDone.iosApp.storeProtocols "Depends on the abstractions in"
        allDone.iosApp.tasksViewModel -> allDone.iosApp.storeProtocols "Depends on the abstractions in"
        allDone.iosApp.settingsViewModel -> allDone.iosApp.storeProtocols "Depends on the abstractions in"
        allDone.iosApp.appStartingViewModel -> allDone.iosApp.storeProtocols "Depends on the abstractions in"

        // ---------------------------------------------------------------
        // Relationships: components — domain usage
        // ---------------------------------------------------------------
        allDone.iosApp.tasksViewModel -> allDone.iosApp.domainModels "Filters, sorts and partitions TodoList and TodoTask values"
        allDone.iosApp.authViewModel -> allDone.iosApp.domainModels "Builds AppUser, AuthType and AppAlert values"
        allDone.iosApp.settingsViewModel -> allDone.iosApp.domainModels "Maps AppUser into InfoData rows"
        allDone.iosApp.appStartingViewModel -> allDone.iosApp.domainModels "Publishes AppState"
        allDone.iosApp.authViewModel -> allDone.iosApp.displayProtocols "Conforms to, to surface alerts and errors"
        allDone.iosApp.tasksViewModel -> allDone.iosApp.displayProtocols "Conforms to, to surface alerts and errors"
        allDone.iosApp.settingsViewModel -> allDone.iosApp.displayProtocols "Conforms to, to surface alerts and errors"
        allDone.iosApp.displayProtocols -> allDone.iosApp.domainErrors "Presents AppError values produced by"
        allDone.iosApp.viewExtensions -> allDone.iosApp.displayProtocols "Renders alerts and errors declared by"

        // ---------------------------------------------------------------
        // Relationships: components — stores to Firebase
        // ---------------------------------------------------------------
        allDone.iosApp.authStore -> allDone.iosApp.storeProtocols "Implements"
        allDone.iosApp.userStore -> allDone.iosApp.storeProtocols "Implements"
        allDone.iosApp.todoStore -> allDone.iosApp.storeProtocols "Implements"

        allDone.iosApp.authStore -> firebase.firebaseAuth "Creates users, signs in and out, and sends password-reset e-mails" "FirebaseAuth SDK / HTTPS"
        allDone.iosApp.userStore -> firebase.firestore "Reads and writes documents in the 'users' collection" "FirebaseFirestore SDK / gRPC"
        allDone.iosApp.todoStore -> firebase.firestore "Reads, writes and deletes documents in 'todo_Lists' and its 'tasks' sub-collection" "FirebaseFirestore SDK / gRPC"
        allDone.iosApp.todoStore -> allDone.iosApp.firestoreHelpers "Decodes query results and registers snapshot listeners through"
        allDone.iosApp.userStore -> allDone.iosApp.firestoreHelpers "Decodes documents through"
        allDone.iosApp.firestoreHelpers -> firebase.firestore "Runs queries and registers realtime snapshot listeners against" "FirebaseFirestore SDK / gRPC"
        allDone.iosApp.todoStore -> allDone.iosApp.domainModels "Encodes and decodes TodoList and TodoTask documents"
        allDone.iosApp.userStore -> allDone.iosApp.domainModels "Encodes and decodes AppUser documents"
        allDone.iosApp.authStore -> allDone.iosApp.domainModels "Produces AuthData values"
        allDone.iosApp.authStore -> allDone.iosApp.domainErrors "Surfaces AuthError values from"
        allDone.iosApp.todoStore -> allDone.iosApp.domainErrors "Surfaces DatabaseError values from"

        // ---------------------------------------------------------------
        // Deployment
        // ---------------------------------------------------------------
        deploymentEnvironment "Production" {

            deploymentNode "User's iPhone / iPad" "The user's personal device." "iOS" {
                deploymentNode "AllDone.app" "Signed application bundle distributed through the App Store." "iOS App Bundle" {
                    containerInstance allDone.iosApp
                }
            }

            deploymentNode "Google Cloud Platform" "Google-managed, multi-region infrastructure." "Firebase" {
                deploymentNode "Firebase Auth Service" "" "Managed service" {
                    containerInstance firebase.firebaseAuth
                }
                deploymentNode "Cloud Firestore" "" "Managed NoSQL database, multi-region" {
                    containerInstance firebase.firestore
                }
                deploymentNode "Firebase Analytics" "" "Managed service" {
                    containerInstance firebase.analytics
                }
            }
        }
    }

    views {

        // ---------------------------------------------------------------
        // Level 1 — System Context
        // ---------------------------------------------------------------
        systemContext allDone "SystemContext" "Level 1: how AllDone fits into the world around it." {
            include *
            autoLayout lr
        }

        // ---------------------------------------------------------------
        // Level 2 — Containers
        // ---------------------------------------------------------------
        container allDone "Containers" "Level 2: the iOS app and the Firebase services it depends on." {
            include *
            autoLayout lr
        }

        // ---------------------------------------------------------------
        // Level 3 — Components
        // ---------------------------------------------------------------
        component allDone.iosApp "Components" "Level 3: the MVVM + Store components inside the iOS app." {
            include *
            exclude allDone.iosApp.mockStores
            autoLayout tb
        }

        component allDone.iosApp "ComponentsWithPreviewSupport" "Level 3 (variant): components including the preview-only mock stores." {
            include *
            autoLayout tb
        }

        // ---------------------------------------------------------------
        // Level 4 (dynamic) — key runtime flows
        // ---------------------------------------------------------------
        dynamic allDone.iosApp "SignUpFlow" "Runtime flow: a new user signs up, gets a profile and receives the default to-do lists." {
            user -> allDone.iosApp.authView "1. Enters first name, last name, e-mail and password"
            allDone.iosApp.authView -> allDone.iosApp.authViewModel "2. Calls authenticate()"
            allDone.iosApp.authViewModel -> allDone.iosApp.authStore "3. signUp(email:password:)"
            allDone.iosApp.authStore -> firebase.firebaseAuth "4. createUser(withEmail:password:)"
            allDone.iosApp.authViewModel -> allDone.iosApp.userStore "5. createNewUser(user:)"
            allDone.iosApp.userStore -> firebase.firestore "6. Writes users/{userId}"
            allDone.iosApp.authViewModel -> allDone.iosApp.todoStore "7. setupUser(userId:)"
            allDone.iosApp.todoStore -> firebase.firestore "8. Creates Inbox, Personal, Work and Groceries in todo_Lists"
            allDone.iosApp.appStartingViewModel -> allDone.iosApp.authStore "9. Receives authUpdate and re-reads the current user"
            allDone.iosApp.appStartingView -> allDone.iosApp.appStartingViewModel "10. Observes appState == .app"
            allDone.iosApp.appStartingView -> allDone.iosApp.tasksView "11. Swaps in the task screen"
            autoLayout lr
        }

        dynamic allDone.iosApp "RealtimeSyncFlow" "Runtime flow: the task screen subscribes to Firestore snapshot listeners and re-renders on every change." {
            user -> allDone.iosApp.tasksView "1. Opens the task screen"
            allDone.iosApp.tasksView -> allDone.iosApp.tasksViewModel "2. Observes @Published lists and tasks"
            allDone.iosApp.tasksViewModel -> allDone.iosApp.todoStore "3. getTodoLists(for:), then todoListsPublisher / taskPublisher"
            allDone.iosApp.todoStore -> allDone.iosApp.firestoreHelpers "4. addSnapshotListener(as:) wraps each query"
            allDone.iosApp.firestoreHelpers -> firebase.firestore "5. Registers realtime listeners; every change emits over Combine"
            allDone.iosApp.tasksViewModel -> allDone.iosApp.domainModels "6. Filters by search text, sorts by date and partitions completed tasks"
            allDone.iosApp.tasksView -> allDone.iosApp.sharedComponents "7. Re-renders TodoListNameView and TaskCompactView rows"
            autoLayout lr
        }

        dynamic allDone.iosApp "AddTaskFlow" "Runtime flow: the user adds a task to the selected to-do list." {
            user -> allDone.iosApp.tasksView "1. Taps the + button"
            allDone.iosApp.tasksView -> allDone.iosApp.sharedComponents "2. Presents NewTodoView for name and description"
            allDone.iosApp.tasksView -> allDone.iosApp.tasksViewModel "3. addTask(name:description:)"
            allDone.iosApp.tasksViewModel -> allDone.iosApp.todoStore "4. addTask(todoListId:name:description:)"
            allDone.iosApp.todoStore -> firebase.firestore "5. Writes todo_Lists/{listId}/tasks/{taskId}"
            allDone.iosApp.firestoreHelpers -> firebase.firestore "6. The active snapshot listener pushes the new task back to the app"
            autoLayout lr
        }

        // ---------------------------------------------------------------
        // Deployment
        // ---------------------------------------------------------------
        deployment * "Production" "Deployment" "Where each container runs in production." {
            include *
            autoLayout lr
        }

        // ---------------------------------------------------------------
        // Styles
        // ---------------------------------------------------------------
        styles {
            element "Element" {
                fontSize 22
                shape RoundedBox
                color #ffffff
            }
            element "Person" {
                shape Person
                background #08427b
                color #ffffff
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Internal System" {
                background #1168bd
                color #ffffff
            }
            element "External System" {
                background #999999
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Mobile App" {
                shape MobileDeviceLandscape
                background #438dd5
                color #ffffff
            }
            element "External Container" {
                background #b3b3b3
                color #ffffff
            }
            element "Database" {
                shape Cylinder
                background #b3b3b3
                color #ffffff
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
            element "Presentation" {
                background #85bbf0
                color #000000
            }
            element "ViewModel" {
                background #6fb1ec
                color #000000
            }
            element "Domain" {
                background #b8d9f5
                color #000000
            }
            element "Data" {
                background #4d94d6
                color #ffffff
            }
            element "Infrastructure" {
                background #cfcfcf
                color #000000
            }
            element "Test Double" {
                background #e8e8e8
                color #000000
                border dashed
            }
            relationship "Relationship" {
                dashed false
                fontSize 20
            }
        }

        theme default
    }
}
