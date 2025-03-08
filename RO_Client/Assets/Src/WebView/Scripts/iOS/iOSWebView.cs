/**
* Copyright (c) 2021 Vuplex Inc. All rights reserved.
*
* Licensed under the Vuplex Commercial Software Library License, you may
* not use this file except in compliance with the License. You may obtain
* a copy of the License at
*
*     https://vuplex.com/commercial-library-license
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
#if UNITY_IOS && !UNITY_EDITOR
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEngine.Rendering;

namespace Vuplex.WebView {
    /// <summary>
    /// The `IWebView` implementation used by 3D WebView for iOS.
    /// This class also includes extra methods for iOS-specific functionality.
    /// </summary>
    public class iOSWebView : BaseWebView, IWebView {

        public WebPluginType PluginType {
            get {
                return WebPluginType.iOS;
            }
        }

        public static iOSWebView Instantiate() {

            return (iOSWebView) new GameObject().AddComponent<iOSWebView>();
        }

        public override void Init(Texture2D viewportTexture, float width, float height, Texture2D videoTexture) {

            base.Init(viewportTexture, width, height, videoTexture);
            _nativeWebViewPtr = WebView_new(
                gameObject.name,
                _nativeWidth,
                _nativeHeight,
                videoTexture != null,
                SystemInfo.graphicsDeviceType != GraphicsDeviceType.Metal
            );
        }

        public override void Click(Vector2 point, bool preventStealingFocus) {

            _assertValidState();
            if (preventStealingFocus) {
                int nativeX = (int) (point.x * _nativeWidth);
                int nativeY = (int) (point.y * _nativeHeight);
                WebView_clickWithoutStealingFocus(_nativeWebViewPtr, nativeX, nativeY);
            } else {
                Click(point);
            }
        }

        /// <summary>
        /// Overrides `BaseWebView.CaptureScreenshot()` because it uses too much
        /// memory on iOS.
        /// </summary>
        public override void CaptureScreenshot(Action<byte[]> callback) {

            _assertValidState();
            IntPtr unmanagedBytes = IntPtr.Zero;
            int unmanagedBytesLength = 0;
            WebView_captureScreenshot(_nativeWebViewPtr, ref unmanagedBytes, ref unmanagedBytesLength);

            // Load the results into a managed array.
            var managedBytes = new byte[unmanagedBytesLength];
            Marshal.Copy(unmanagedBytes, managedBytes, 0, unmanagedBytesLength);
            WebView_freeMemory(unmanagedBytes);
            callback(managedBytes);
        }

        public override void EnableViewUpdates() {

            if (_currentVideoNativeTexture != IntPtr.Zero) {
                _videoTexture.UpdateExternalTexture(_currentVideoNativeTexture);
            }
            base.EnableViewUpdates();
        }

        /// <summary>
        /// Returns a file URL for resource included in the iOS app bundle.
        /// </summary>
        /// <remarks>
        /// This is useful for getting a file URL to a local file so that it
        /// can be loaded via `IWebView.LoadUrl()`.
        /// </remarks>
        /// <example>
        /// var fileUrl = iOSWebView.GetFileUrlForBundleResource("my-static-files/my-webpage.html");
        /// </example>
        [Obsolete("iOSWebView.GetFileUrlForBundleResource is now deprecated. You can now use LoadUrl(\"streaming-assets://{path}\") to load a file from StreamingAssets instead.")]
        public static string GetFileUrlForBundleResource(string fileName) {

            var fileNameSegments = fileName.Split(new char[] {'.'});
            if (fileNameSegments.Length < 2) {
                throw new ArgumentException(String.Format("The file name must include an extension, but the name provided ({0}) does not.", fileName));
            }

            var fileExtension = fileNameSegments[fileNameSegments.Length - 1];
            var fileNameWithoutExtension = String.Join(".", fileNameSegments.ToList().GetRange(0, fileNameSegments.Length - 1).ToArray());

            var stringPtr = WebView_getFileUrlForBundleResource(fileNameWithoutExtension, fileExtension);
            var fileUrl = Marshal.PtrToStringAnsi(stringPtr);
            return fileUrl;
        }

        /// <summary>
        /// Overrides `BaseWebView.GetRawTextureData()` because it uses too much
        /// memory on iOS.
        /// </summary>
        public override void GetRawTextureData(Action<byte[]> callback) {

            _assertValidState();
            IntPtr unmanagedBytes = IntPtr.Zero;
            int unmanagedBytesLength = 0;
            WebView_getRawTextureData(_nativeWebViewPtr, ref unmanagedBytes, ref unmanagedBytesLength);

            // Load the results into a managed array.
            var managedBytes = new byte[unmanagedBytesLength];
            Marshal.Copy(unmanagedBytes, managedBytes, 0, unmanagedBytesLength);
            WebView_freeMemory(unmanagedBytes);
            callback(managedBytes);
        }


        [Obsolete("iOSWebView.SetCustomUriSchemesEnabled() has been removed. Now when a page redirects to a URI with a custom scheme, 3D WebView will automatically emit the UrlChanged and LoadProgressChanged events for the navigation, but a deep link (i.e. to an external application) won't occur.", true)]
        public static void SetCustomUriSchemesEnabled(bool enabled) {}

        public static void SetIgnoreCertificateErrors(bool ignore) {

            WebView_setIgnoreCertificateErrors(ignore);
        }

        [Obsolete("iOSWebView.SetNativeKeyboardEnabled() is now deprecated. Please use Web.SetTouchScreenKeyboardEnabled() instead.")]
        public static void SetNativeKeyboardEnabled(bool enabled) {

            SetTouchScreenKeyboardEnabled(enabled);
        }

        public static void SetTouchScreenKeyboardEnabled(bool enabled) {

            WebView_setTouchScreenKeyboardEnabled(enabled);
        }

        /// <summary>
        /// Like `Web.SetUserAgent(bool mobile)`, except it sets the user-agent
        /// for a single webview instance instead of setting it globally.
        /// </summary>
        /// <remarks>
        /// If you globally set a default user-agent using `Web.SetUserAgent()`,
        /// you can still use this method to override the user-agent for a
        /// single webview instance.
        /// </remarks>
        public void SetUserAgent(bool mobile) {

            _assertValidState();
            WebView_setUserAgentToMobile(_nativeWebViewPtr, mobile);
        }

        /// <summary>
        /// Like `Web.SetUserAgent(string userAgent)`, except it sets the user-agent
        /// for a single webview instance instead of setting it globally.
        /// </summary>
        /// <remarks>
        /// If you globally set a default user-agent using `Web.SetUserAgent()`,
        /// you can still use this method to override the user-agent for a
        /// single webview instance.
        /// </remarks>
        public void SetUserAgent(string userAgent) {

            _assertValidState();
            WebView_setUserAgent(_nativeWebViewPtr, userAgent);
        }

        IntPtr _currentVideoNativeTexture;
        readonly WaitForEndOfFrame _waitForEndOfFrame = new WaitForEndOfFrame();

        void _applyVideoTexture() {

            if (_currentVideoNativeTexture == IntPtr.Zero) {
                return;
            }
            var previousNativeTexturePtr = _videoTexture.GetNativeTexturePtr();
            _videoTexture.UpdateExternalTexture(_currentVideoNativeTexture);
            _videoTexture.Apply();
            var newNativeTexturePtr = _videoTexture.GetNativeTexturePtr();
            if (!(previousNativeTexturePtr == IntPtr.Zero || previousNativeTexturePtr == newNativeTexturePtr)) {
                WebView_destroyTexture(previousNativeTexturePtr, SystemInfo.graphicsDeviceType.ToString());
            }
        }

        /// <summary>
        /// The native plugin invokes this method.
        /// </summary>
        void HandleVideoTextureChanged(string textureString) {

            var nativeTexture = new IntPtr(Int64.Parse(textureString));
            if (nativeTexture == _currentVideoNativeTexture) {
                return;
            }
            var previousNativeTexture = _currentVideoNativeTexture;
            _currentVideoNativeTexture = nativeTexture;
            if (_viewUpdatesAreEnabled) {
                _videoTexture.UpdateExternalTexture(_currentVideoNativeTexture);
            }

            if (previousNativeTexture != IntPtr.Zero && previousNativeTexture != _currentVideoNativeTexture) {
                WebView_destroyTexture(previousNativeTexture, SystemInfo.graphicsDeviceType.ToString());
            }
        }

        void OnEnable() {

            // Start the coroutine from OnEnable so that the coroutine
            // is restarted if the object is deactivated and then reactivated.
            StartCoroutine(_renderPluginOncePerFrame());
        }

        IEnumerator _renderPluginOncePerFrame() {

            while (true) {
                yield return _waitForEndOfFrame;

                if (!_viewUpdatesAreEnabled || IsDisposed) {
                    continue;
                }
                int pointerId = WebView_depositPointer(_nativeWebViewPtr);
                GL.IssuePluginEvent(WebView_getRenderFunction(), pointerId);
            }
        }

        [DllImport(_dllName)]
        private static extern void WebView_captureScreenshot(IntPtr webViewPtr, ref IntPtr bytes, ref int length);

        [DllImport(_dllName)]
        static extern void WebView_clickWithoutStealingFocus(IntPtr webViewPtr, int x, int y);

        [DllImport(_dllName)]
        static extern int WebView_depositPointer(IntPtr pointer);

        [DllImport(_dllName)]
        static extern void WebView_freeMemory(IntPtr bytes);

        [DllImport(_dllName)]
        static extern IntPtr WebView_getFileUrlForBundleResource(string fileNameWithoutExtension, string fileExtension);

        [DllImport(_dllName)]
        static extern void WebView_getRawTextureData(IntPtr webViewPtr, ref IntPtr bytes, ref int length);

        [DllImport(_dllName)]
        static extern IntPtr WebView_getRenderFunction();

        [DllImport(_dllName)]
        static extern IntPtr WebView_new(string gameObjectName, int width, int height, bool enableVideoSupport, bool useOpenGL);

        [DllImport(_dllName)]
        static extern void WebView_setIgnoreCertificateErrors(bool ignore);

        [DllImport(_dllName)]
        static extern void WebView_setTouchScreenKeyboardEnabled(bool enabled);

        [DllImport(_dllName)]
        static extern void WebView_setUserAgentToMobile(IntPtr webViewPtr, bool mobile);

        [DllImport(_dllName)]
        static extern void WebView_setUserAgent(IntPtr webViewPtr, string userAgent);
    }
}
#endif
