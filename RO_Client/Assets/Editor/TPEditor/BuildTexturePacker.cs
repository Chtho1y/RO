#if UNITY_EDITOR
using UnityEngine;
using System.IO;
using UnityEditor;
using System.Text;
using System.Diagnostics;
public class CommandBuild : Editor
{
    public static string inputPath = string.Format("{0}/Content/Raw_Art/UI", Application.dataPath);//小图目录
    public static string outputPath = string.Format("{0}/Content/Altas", Application.dataPath);//用TP打包好的图集存放目录

    [MenuItem("Tools/SpritesPacker/CommandBuild")]
    public static void BuildTexturePacker()
    {
        //选择并设置TP命令行的参数和参数值
        string commandText = " --sheet {0}.png --data {1}.xml --format sparrow --trim-mode None --pack-mode Best --smart-update --algorithm MaxRects --max-size 2048 --size-constraints POT  --disable-rotation --scale 1 {2}";
        string[] imagePath = Directory.GetDirectories (inputPath); 
        for (int i = 0; i < imagePath.Length; ++i) 
        {
            UnityEngine.Debug.Log (imagePath [i]);
            StringBuilder sb = new StringBuilder("");
            string[] fileName = Directory.GetFiles(imagePath[i]);
            for (int j = 0; j < fileName.Length; ++j)
            {
                string extenstion = Path.GetExtension(fileName[j]);
                if (extenstion == ".png")
                {
                    sb.Append(fileName[j]);
                    sb.Append("  ");
                    UnityEngine.Debug.Log("fileName [j]:" + fileName[j]);
                }
            }
            string name = Path.GetFileName(imagePath [i]);
            string outputName = string.Format ("{0}/{1}", outputPath, name);
            string sheetName = string.Format("{0}/TP/SheetsByTP/{1}", Application.dataPath, name);
            //执行命令行
            processCommand("D:/TexturePacker/bin/TexturePacker.exe", string.Format(commandText, sheetName, sheetName, sb.ToString()));
        }
        AssetDatabase.Refresh();
    }

    private static void processCommand(string command, string argument)
    {
        ProcessStartInfo start = new ProcessStartInfo(command);
        start.Arguments = argument;
        start.CreateNoWindow = false;
        start.ErrorDialog = true;
        start.UseShellExecute = false;

        if(start.UseShellExecute){
            start.RedirectStandardOutput = false;
            start.RedirectStandardError = false;
            start.RedirectStandardInput = false;
        } else{
            start.RedirectStandardOutput = true;
            start.RedirectStandardError = true;
            start.RedirectStandardInput = true;
            start.StandardOutputEncoding = System.Text.UTF8Encoding.UTF8;
            start.StandardErrorEncoding = System.Text.UTF8Encoding.UTF8;
        }

        Process p = Process.Start(start);
        if(!start.UseShellExecute)
        {
            UnityEngine.Debug.Log(p.StandardOutput.ReadToEnd());
            UnityEngine.Debug.Log(p.StandardError.ReadToEnd());
        }

        p.WaitForExit();
        p.Close();
    }

}
#endif