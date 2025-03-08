using System.IO;
using System.Linq;

public static class FileUtils
{
    /// <summary>
    /// 遍历文件夹中的文件【仅仅遍历当前目录】
    /// </summary>
    /// <param name="dir"></param>
    /// <param name="filter"></param>
    /// <param name="option"></param>
    /// <returns></returns>
    public static string[] TraverseFiles(string dir, string filter, string option = "")
    {
        if (string.IsNullOrEmpty(option))
            return Directory.GetFiles(dir, filter, SearchOption.TopDirectoryOnly);
        else
            return Directory.GetFiles(dir, filter, SearchOption.TopDirectoryOnly).Where(s => option.Contains(Path.GetExtension(s).ToLower())).ToArray();
    }

    /// <summary>
    /// 遍历文件夹中的文件
    /// </summary>
    /// <param name="dir">文件夹</param>
    /// <param name="filter">查找的文件后缀</param>
    /// <param name="option"></param>
    /// <returns></returns>
    public static string[] TraverseAllFiles(string dir, string filter, string option = "")
    {
        if (string.IsNullOrEmpty(option))
            return Directory.GetFiles(dir, filter, SearchOption.AllDirectories);
        else
            return Directory.GetFiles(dir, filter, SearchOption.AllDirectories).Where(s => option.Contains(Path.GetExtension(s).ToLower())).ToArray();
    }

    /// <summary>
    /// 获取资源相对路径
    /// </summary>
    /// <param name="filePath">资源路径</param>
    /// <returns>在Editor下的资源相对路径</returns>
    public static string ExtractAssetRelativePath(string filePath)
    {
        filePath = filePath.Replace('\\', '/');
        int pos = filePath.IndexOf("Assets");
        if (pos == -1)
            return string.Empty;

        string relativePath = filePath.Substring(pos, filePath.Length - pos);
        return relativePath;
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

    /// <summary>
    /// 文件是否有后缀
    /// </summary>
    /// <param name="fileName"></param>
    /// <returns></returns>
    public static bool HasExtension(string fileName)
    {
        int pos = fileName.LastIndexOf(".");
        if (pos == -1)
            return false;

        return true;
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
    /// 获取文件所在目录
    /// </summary>
    /// <param name="filePath"></param>
    /// <returns></returns>
    public static bool ExtractParent(string filePath, out string dir)
    {
        dir = null;
        filePath = filePath.Replace('\\', '/');
        int pos = filePath.LastIndexOf("/");
        if (pos == -1)
            return false;

        dir = filePath.Substring(0, pos);
        return true;
    }

    public static string RemoveParent(string parent, string filePath)
    {
        filePath = filePath.Replace('\\', '/');
        int pos = filePath.IndexOf(parent);
        if (pos == -1)
            return filePath;

        string relativePath = filePath.Substring(parent.Length + 1);
        return relativePath;
    }

    public static void WriteFile(string path, string info)
    {
        StreamWriter sw;
        FileInfo t = new FileInfo(path);
        if (!t.Exists)
        {
            sw = t.CreateText();
        }
        else
        {
            sw = t.AppendText();
        }
        sw.WriteLine(info);
        sw.Close();
        sw.Dispose();
    }


}
