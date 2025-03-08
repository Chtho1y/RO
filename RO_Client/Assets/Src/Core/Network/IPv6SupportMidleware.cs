using System.Text;
using UnityEngine;
using System.Collections.Generic;
using System;
using System.Net.Sockets;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;


public class IPv6SupportMidleware
{

#if UNITY_IOS && !UNITY_EDITOR
	[DllImport("__Internal")]
	private static extern string getIPv6(string mHost);  
#endif

    private static string GetIPv6 (string host) {
        #if UNITY_IOS && !UNITY_EDITOR
            return getIPv6 (host);
        #else
            return host + "&&ipv4";
        #endif
    }

	// Get IP type and synthesize IPv6, if needed, for iOS
    private static void GetIPType (string serverIp, out String newServerIp, out AddressFamily IPType) {
        IPType = AddressFamily.InterNetwork;
        newServerIp = serverIp;
        try {
            string IPv6 = GetIPv6 (serverIp);
            if (!string.IsNullOrEmpty (IPv6)) {
                string[] tmp = Regex.Split (IPv6, "&&");
                if (tmp != null && tmp.Length >= 2) {
                    string type = tmp[1];
                    if (type == "ipv6") {
                        newServerIp = tmp[0];
                        IPType = AddressFamily.InterNetworkV6;
                    }
                }
            }
        } catch (Exception e) {
			Debug.LogErrorFormat ("GetIPv6 error: {0}", e.Message);
        }
    }

	// Get IP address by AddressFamily and domain
	private static string GetIPAddress (string hostName, AddressFamily addressFamily) {
        if (addressFamily == AddressFamily.InterNetworkV6 && !System.Net.Sockets.Socket.OSSupportsIPv6)
            return null;
		if (string.IsNullOrEmpty (hostName))
			return null;
        
		System.Net.IPHostEntry host;
		string connectIP = "";
		try {
			host = System.Net.Dns.GetHostEntry (hostName);
			foreach (System.Net.IPAddress ip in host.AddressList) {
				if (ip.AddressFamily == addressFamily) {
					connectIP = ip.ToString ();
                }
			}
		} catch (Exception e) {
			Debug.LogErrorFormat ("GetIPAddress error: {0}", e.Message);
		}
		return connectIP;
    }

	// Check IP or not
	private static bool IsIPAddress (string data) {
		Match match = Regex.Match (data, @"\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b");
        if (match == null)
        {
            return false;
        }
		return match.Success;
	}

    public static bool GetValidServerIpInfo(string hostNameOrIp, out String newServerIp, out AddressFamily IPType)
    {
        if (IsIPAddress(hostNameOrIp)) {
            GetIPType(hostNameOrIp, out newServerIp, out IPType);
        }
        else
        {
            newServerIp = GetIPAddress(hostNameOrIp, AddressFamily.InterNetworkV6);
            if (string.IsNullOrEmpty(newServerIp))
            {
                newServerIp = GetIPAddress(hostNameOrIp, AddressFamily.InterNetwork);
                IPType = AddressFamily.InterNetwork;
            }
            else
            {
                IPType = AddressFamily.InterNetworkV6;
            }
        }
        if (string.IsNullOrEmpty(newServerIp))
        {
            return false;
        }

        return true;
    }
}