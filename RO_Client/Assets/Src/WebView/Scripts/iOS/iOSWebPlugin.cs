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
using UnityEngine;

namespace Vuplex.WebView {

    class iOSWebPlugin : IWebPlugin, IPluginWithTouchScreenKeyboard {

        public static iOSWebPlugin Instance {
            get {
                if (_instance == null) {
                    _instance = new iOSWebPlugin();
                }
                return _instance;
            }
        }

        public WebPluginType Type {
            get {
                return WebPluginType.iOS;
            }
        }

        public void ClearAllData() {

            iOSWebView.ClearAllData();
        }

        public void CreateTexture(float width, float height, Action<Texture2D> callback) {

            iOSWebView.CreateTexture(width, height, callback);
        }

        public void CreateMaterial(Action<Material> callback) {

            CreateTexture(1, 1, texture => {
                Material material = null;
                Shader shader = ResourceMgr.Instance.FindShader("Vuplex/Viewport Shader", "Assets/Shaders/WebView/Common/ViewportShader");
                if (shader)
                {
                    material = new Material(shader);
                    material.mainTexture = texture;
                    material.renderQueue = 3000;
                }
                callback(material);
            });
        }

        public void CreateVideoMaterial(Action<Material> callback) {

            CreateTexture(1, 1, texture => {
                Material material = null;
                Shader shader = ResourceMgr.Instance.FindShader("Vuplex/Viewport Shader", "Assets/Shaders/WebView/Common/ViewportShader");
                if (shader)
                {
                    material = new Material(shader);
                    material.mainTexture = texture;
                    material.EnableKeyword("FLIP_Y");
                    material.SetFloat("_FlipY", 1);
                    material.renderQueue = 2999;
                }
                callback(material);
            });
        }

        public virtual IWebView CreateWebView() {

            return iOSWebView.Instantiate();
        }

        public void EnableRemoteDebugging() {

            WebViewLogger.Log("Remote debugging is enabled for iOS. For instructions, please see https://support.vuplex.com/articles/how-to-debug-web-content#ios.");
        }

        public void SetIgnoreCertificateErrors(bool ignore) {

            iOSWebView.SetIgnoreCertificateErrors(ignore);
        }

        public void SetStorageEnabled(bool enabled) {

            iOSWebView.SetStorageEnabled(enabled);
        }

        /// <see cref="IPluginWithTouchScreenKeyboard"/>
        public void SetTouchScreenKeyboardEnabled(bool enabled) {

            iOSWebView.SetTouchScreenKeyboardEnabled(enabled);
        }

        public void SetUserAgent(bool mobile) {

            iOSWebView.GloballySetUserAgent(mobile);
        }

        public void SetUserAgent(string userAgent) {

            iOSWebView.GloballySetUserAgent(userAgent);
        }

        static iOSWebPlugin _instance;
    }
}
#endif
