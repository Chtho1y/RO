using System;
using System.IO;
using System.Collections.Generic;
using UnityEngine;
using System.Text;

public class FileSystem 
{
    private static string CachedSerializeRootPath;
    public static string serializeRootPath
    {
        get
        {
            if (CachedSerializeRootPath == null)
            {
#if UNITY_EDITOR
                string folder = string.Format("{0}/../../serialize/", Application.dataPath);
#elif UNITY_STANDALONE
                string folder = string.Format("{0}/../serialize/", Application.dataPath);
#else
                string folder = string.Format("{0}/serialize/", Application.persistentDataPath);
#endif

                if (!Directory.Exists(folder))
                {
                    Directory.CreateDirectory(folder);
                }

                CachedSerializeRootPath = folder;
            }

            return CachedSerializeRootPath;
        }
    }

    /// <summary>
    /// 依据不同平台，获取assetbunldes目录
    /// </summary>
    /// 
    private static string m_PackagePath = string.Empty;
    public static string PackagePath()
    {

        if (string.IsNullOrEmpty(m_PackagePath))
        {

#if UNITY_IPHONE
#if UNITY_EDITOR
		    m_PackagePath = Application.dataPath + "/../ios/";
#else
		    m_PackagePath = Application.dataPath + "/Raw/ios/";
#endif
#elif UNITY_ANDROID
#if UNITY_EDITOR
            m_PackagePath = Application.dataPath + "/../AssetsAndroid/";
#else
		    m_PackagePath = Application.dataPath + "!/assets/AssetsAndroid/";
#endif
#else
            m_PackagePath = Application.dataPath + "/../AssetsPC/";

#endif
        }
        return m_PackagePath;
    }

    private static string m_LocalPackagePath = string.Empty;
    public static string LocalPackagePath
    {
        get
        {
            if (string.IsNullOrEmpty(m_LocalPackagePath))
            {
                m_LocalPackagePath = PackagePath();

#if UNITY_EDITOR    //editor
                        //m_LocalPackagePath = "file://" + m_LocalPackagePath;
#elif UNITY_ANDROID  //android release;
		                m_LocalPackagePath = "jar:file://" + m_LocalPackagePath;
#elif UNITY_IPHONE //ios release;
		                //m_LocalPackagePath = "file://" + m_LocalPackagePath;
#else   //pc release;
                    m_PackagePath = Application.streamingAssetsPath + "/AssetsPC/";
#endif
            }
            return m_LocalPackagePath;
        }
    }

    public static string LocalUrlPath
    {
        get
        {
            if (string.IsNullOrEmpty(m_LocalPackagePath))
            {
                m_LocalPackagePath = PackagePath();

#if UNITY_EDITOR    //editor
                m_LocalPackagePath = "file://" + m_LocalPackagePath;
#elif UNITY_ANDROID  //android release;
		        m_LocalPackagePath = "jar:file://" + m_LocalPackagePath;
#elif UNITY_IPHONE || UNITY_IOS
		        m_LocalPackagePath = "file://" + m_LocalPackagePath;
#else   //pc release;
                m_PackagePath = Application.streamingAssetsPath + "/AssetsPC/";
#endif
            }
            return m_LocalPackagePath;
        }
    }

    private static string m_LocalDocumentPath = string.Empty;
    public static string LocalDocumentPath
    {      
        get
        {
            if (string.IsNullOrEmpty(m_LocalDocumentPath))
            {
                m_LocalDocumentPath = GetUserDocumentPath();
#if UNITY_IPHONE
#if UNITY_EDITOR
            m_LocalDocumentPath = Application.dataPath + "/../Local/ios/";
#else
		    m_LocalDocumentPath = m_LocalDocumentPath + "ios/";
#endif
#elif UNITY_ANDROID
#if UNITY_EDITOR
                m_LocalDocumentPath = Application.dataPath + "/../Local/AssetsAndroid/";
#else
                m_LocalDocumentPath = m_LocalDocumentPath + "AssetsAndroid/";
#endif
#else
            m_LocalDocumentPath = Application.streamingAssetsPath +"/AssetsPC/";
#endif
            }
            return m_LocalDocumentPath;
        }        
    }

    private static string m_TempDocumentPath = string.Empty;
    public static string TempDocumentPath
    {
        get
        {
            if (string.IsNullOrEmpty(m_TempDocumentPath))
            {
                m_TempDocumentPath = GetUserDocumentPath();
#if UNITY_IPHONE
#if UNITY_EDITOR
            m_TempDocumentPath = Application.dataPath + "/../Local/Temp/ios/";
#else
		    m_TempDocumentPath = m_TempDocumentPath + "/Temp/ios/";
#endif
#elif UNITY_ANDROID
#if UNITY_EDITOR
                m_TempDocumentPath = Application.dataPath + "/../Local/Temp/AssetsAndroid/";
#else
                m_TempDocumentPath = m_TempDocumentPath + "/Temp/AssetsAndroid/";
#endif
#else
            m_TempDocumentPath = Application.streamingAssetsPath +"/Temp/AssetsPC/";
#endif
            }
            return m_TempDocumentPath;
        }
    }


    private static string m_PlatformPath = string.Empty;
    public static string PlatformPath
    {
        get
        {
            if (string.IsNullOrEmpty(m_PlatformPath))
            {
#if UNITY_IPHONE
                m_PlatformPath = "ios/";
#elif UNITY_ANDROID
                m_PlatformPath = "AssetsAndroid/";
#else
                m_PlatformPath = "AssetsPC/";
#endif
            }
            return m_PlatformPath;
        }
    }

    private static string m_PatchConfigFile = string.Empty;
    public static string PatchConfigFile
    {
        get
        {
            if (string.IsNullOrEmpty(m_PatchConfigFile))
            {
                #if UNITY_EDITOR    //editor
                                m_PatchConfigFile = string.Format("{0}/appbuildconfig.xml", Application.dataPath);
                #else
                                m_PatchConfigFile = string.Format("{0}appbuildconfig.xml", FileSystem.LocalPackagePath);
                #endif
            }
            return m_PatchConfigFile;
        }
    }

    /// <summary> 
    /// 依据不同平台，获取用户文档目录，即app可自由读写的目录
    /// </summary>
    public static string GetUserDocumentPath()
    {
        string path = null;

#if UNITY_IPHONE
        path = GetiPhoneDocumentsPath();
#elif UNITY_ANDROID
        path = GetAndroidDocumentsPath();
#else 
        path = GetWindowsDocumentsPath();
#endif

        return path;
    }

    /// <summary>
    /// 判断指定文件是否存在
    /// </summary>
    /// <returns>true 表示存在</returns>
    public static bool Exists(string file_path)
    {
        bool is_exist = false;
        is_exist = File.Exists(file_path);
        return is_exist;
    }

    private static string GetiPhoneDocumentsPath()
    {
        // Your game has read+write access to /var/mobile/Applications/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/Library 
        // Application.dataPath returns              
        //   /var/mobile/Applications/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/myappname.app/Data 

        string path = Application.dataPath.Substring(0, Application.dataPath.Length - 5);
        path = path.Substring(0, path.LastIndexOf('/'));
        return path + "/Library/";
        //return path + "/Documents/";
    }

    private static string GetAndroidDocumentsPath()
    {
        return Application.persistentDataPath + "/";//"";//
    }

    private static string GetWindowsDocumentsPath()
    {
        string path = Application.dataPath + "/../";
        return path;
    }

    private static bool CheckEXT(string fileName )
    {
        if (fileName.EndsWith(".prefab") || fileName.EndsWith(".txt") || fileName.EndsWith(".xml") ||
            fileName.EndsWith(".lua") || fileName.EndsWith(".csv") || 
            fileName.EndsWith(".ogg") || fileName.EndsWith(".wav")||
            fileName.EndsWith(".TTF") || fileName.EndsWith(".ttf") ||
            fileName.EndsWith(".bytes") || fileName.EndsWith(".pb"))
            return true;
        else
            return false;
    }

    public static List<string> getAllFilesPath(string path, string searchPattern = "*.*", SearchOption searchOption = SearchOption.AllDirectories)
    {
        List<string> all = new List<string>();

        string[] allFiles = Directory.GetFiles(path, searchPattern, searchOption);
        for (int j = 0; j < allFiles.Length; ++j)
        {
            string fileName = allFiles[j];
            if (CheckEXT(fileName))
            {
                fileName = fileName.Replace(Application.dataPath, "Assets");
                all.Add(fileName);
            }
        }       
        return all;
    }

    public static List<string> getAllDirPath(string path, string searchPattern = "*.*", SearchOption searchOption = SearchOption.AllDirectories)
    {
        List<string> all = new List<string>();

        string[] allFiles = Directory.GetDirectories(path, searchPattern, searchOption);
        for (int j = 0; j < allFiles.Length; ++j)
        {
            string fileName = allFiles[j];
            all.Add(fileName);
        }
        return all;
    }

    public static List<string> getAllFilesPathEX(string path,string searchPattern = "*.*", SearchOption searchOption = SearchOption.AllDirectories)
    {
        List<string> all = new List<string>();

        string[] allFiles = Directory.GetFiles(path, searchPattern, searchOption);
        for (int j = 0; j < allFiles.Length; ++j)
        {
            string fileName = allFiles[j];
            if (CheckEXT(fileName))
            {
                all.Add(fileName);
            }
        }
        return all;
    }

    public static string ReadFileLineOne(string path)
    {
        string[] result = null;
        try
        {
            result = File.ReadAllLines(path);
            if(result.Length > 0)
            {
                return result[0];
            }
        }
        catch (Exception e)
        {
            DebugHelper.LogError(e);
        }
        return string.Empty;
    }

    public static Byte[] ReadFileByte(string path)
    {
        Byte[] result = null;
        try
        {
            result = File.ReadAllBytes(path);
        }
        catch (Exception e)
        {
            DebugHelper.LogError(e);
        }
        return result;
    }

    public static string[] ReadFileLines(string path)
    {
        string[] result = null;
        try
        {
            result = File.ReadAllLines(path);
        }
        catch (Exception e)
        {
            DebugHelper.LogError(e);
        }
        return result;
    }

    public static void WriteAllBytes(string path, byte[] data)
    {
        WriteAllBytes(path, data, 0, data.Length);
    }

    public static void WriteAllBytes(string path, byte[] data, int start, int count)
    {
        string directoryName = Path.GetDirectoryName(path);
        CreateDirIfNotExist(directoryName);
        if (File.Exists(path))
        {
            File.Delete(path);
        }
        using (FileStream fileStream = File.OpenWrite(path))
        {
            fileStream.Write(data, start, count);
            fileStream.Close();
        }
    }

    public static void CreateDirIfNotExist(string dir)
    {
        if (!Directory.Exists(dir))
        {
            Directory.CreateDirectory(dir);
        }
    }


    public static void ReleaseFilesFromDirToDir(string from,string to)
    {
        CopyFolder(from, to);
    }

    /// <summary>
    /// 获取文件名字，去掉文件的目录
    /// </summary>
    /// <param name="filePath"></param>
    /// <returns></returns>
    public static string ExtractPureName(string filePath)
    {
        filePath = filePath.Replace('\\', '/');
        int pos = filePath.LastIndexOf("/");
        if (pos == -1)
            return filePath;

        return filePath.Substring(pos + 1, filePath.Length - pos - 1);
    }

    /// <summary>
    /// 去掉文件后缀
    /// </summary>
    /// <param name="fileName">文件名字</param>
    /// <returns></returns>
    public static string RemoveExtension(string fileName)
    {
        int pos = fileName.LastIndexOf(".");
        if (pos == -1)
            return fileName;

        return fileName.Substring(0, pos);
    }

    private static void CopyFolder(string from, string to)
    {
        string[] dirs = Directory.GetDirectories(from);
        FileSystem.CreateDirIfNotExist(to);
        foreach (string sub in dirs)
        {
            string path = to + Path.GetFileName(sub);
            if (!Directory.Exists(path))
                Directory.CreateDirectory(to + Path.GetFileName(sub));
            CopyFolder(sub + "\\", path + "\\");
        }
        string[] files = Directory.GetFiles(from);

        foreach (string file in files)
            File.Copy(file, to + Path.GetFileName(file), true);
    }
}

