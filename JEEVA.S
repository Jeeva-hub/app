PackageInfo webViewPackageInfo = WebViewCompat.getCurrentWebViewPackage(appContext);
Log.d("MY_APP_TAG", "WebView version: " + webViewPackageInfo.versionName);
<manifest>
    <application>
        <meta-data android:name="android.webkit.WebView.EnableSafeBrowsing"
                   android:value="false" />
        ...
    </application>
</manifest>
private WebView superSafeWebView;
private boolean safeBrowsingIsInitialized;

// ...

@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    superSafeWebView = new WebView(this);
    superSafeWebView.setWebViewClient(new MyWebViewClient());
    safeBrowsingIsInitialized = false;

    if (WebViewFeature.isFeatureSupported(WebViewFeature.START_SAFE_BROWSING)) {
        WebViewCompat.startSafeBrowsing(this, new ValueCallback<Boolean>() {
            @Override
            public void onReceiveValue(Boolean success) {
                safeBrowsingIsInitialized = true;
                if (!success) {
                    Log.e("MY_APP_TAG", "Unable to initialize Safe Browsing!");
                }
            }
        });
    }
}
public class MyWebViewClient extends WebViewClientCompat {
    // Automatically go "back to safety" when attempting to load a website that
    // Google has identified as a known threat. An instance of WebView calls
    // this method only after Safe Browsing is initialized, so there's no
    // conditional logic needed here.
    @Override
    public void onSafeBrowsingHit(WebView view, WebResourceRequest request,
            int threatType, SafeBrowsingResponseCompat callback) {
        // The "true" argument indicates that your app reports incidents like
        // this one to Safe Browsing.
        if (WebViewFeature.isFeatureSupported(WebViewFeature.SAFE_BROWSING_RESPONSE_BACK_TO_SAFETY)) {
            callback.backToSafety(true);
            Toast.makeText(view.getContext(), "Unsafe web page blocked.",
                    Toast.LENGTH_LONG).show();
        }
    }
}
<manifest>
    <application>
    ...
    <meta-data android:name="android.webkit.WebView.MetricsOptOut"
               android:value="true" />
    </application>
</manifest>
public class MyRendererTrackingWebViewClient extends WebViewClient {
    private WebView mWebView;

    @Override
    public boolean onRenderProcessGone(WebView view,
            RenderProcessGoneDetail detail) {
        if (!detail.didCrash()) {
            // Renderer was killed because the system ran out of memory.
            // The app can recover gracefully by creating a new WebView instance
            // in the foreground.
            Log.e("MY_APP_TAG", "System killed the WebView rendering process " +
                    "to reclaim memory. Recreating...");

            if (mWebView != null) {
                ViewGroup webViewContainer =
                        (ViewGroup) findViewById(R.id.my_web_view_container);
                webViewContainer.removeView(mWebView);
                mWebView.destroy();
                mWebView = null;
            }

            // By this point, the instance variable "mWebView" is guaranteed
            // to be null, so it's safe to reinitialize it.

            return true; // The app continues executing.
        }

        // Renderer crashed because of an internal error, such as a memory
        // access violation.
        Log.e("MY_APP_TAG", "The WebView rendering process crashed!");

        // In this example, the app itself crashes after detecting that the
        // renderer crashed. If you choose to handle the crash more gracefully
        // and allow your app to continue executing, you should 1) destroy the
        // current WebView instance, 2) specify logic for how the app can
        // continue executing, and 3) return "true" instead.
        return false;
    }
}
WebView myWebView;
myWebView.setRendererPriorityPolicy(RENDERER_PRIORITY_BOUND, true);



---------------------------------------------------------------------------------

implementation 'com.google.firebase:firebase-dynamic-links:19.1.0'
implementation 'com.google.firebase:firebase-analytics:17.4.3'
<intent-filter>
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data
        android:host="example.com"
        android:scheme="https"/>
</intent-filter>
FirebaseDynamicLinks.getInstance()
        .getDynamicLink(getIntent())
        .addOnSuccessListener(this, new OnSuccessListener<PendingDynamicLinkData>() {
            @Override
            public void onSuccess(PendingDynamicLinkData pendingDynamicLinkData) {
                // Get deep link from result (may be null if no link is found)
                Uri deepLink = null;
                if (pendingDynamicLinkData != null) {
                    deepLink = pendingDynamicLinkData.getLink();
                }


                // Handle the deep link. For example, open the linked
                // content, or apply promotional credit to the user's
                // account.
                // ...

                // ...
            }
        })
        .addOnFailureListener(this, new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                Log.w(TAG, "getDynamicLink:onFailure", e);
            }
        });
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data android:host="example.com/link" android:scheme="http"/>
    <data android:host="example.com/link" android:scheme="https"/>
</intent-filter>




