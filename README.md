
<h1 align="center">ProProfs Chat SDK for iOS</h1>

## Step 1. Integration

#### Using Swift Package Manager (SPM)

```
Step 1: Select File -> Add Packages...
Step 2: Search url https://github.com/ProProfs-Workflow/chat_ios_sdk
Step 3: Select Depedency Rule -> Exact Version -> 0.0.1
Step 4: Click the button "Add Package" 
Step 5: Check if the package is added at Target -> General -> Framework, Libraries, and Embedded Content
```
## Step 2. Code Integration
```
   import ProProfsChatIosSDK
   ProProfsChatIosSDK(site_id: "api-key")
```
Eg.
```
import SwiftUI
import ProProfsChatIosSDK

struct ContentView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                List{
                        Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry")                    
                    }
            }.overlay(alignment:.bottomTrailing, content: {
              ProProfsChatIosSDK(site_id: "api-key")
                    .padding(.trailing,30)
                    .padding(.bottom,30)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}      
```

