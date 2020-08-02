using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;

[DotNetType(null)]
public extern(CIL) static class SQLiteImpl {

	public static extern string OpenImpl(string filename);

	public static extern void ExecImpl(string handler, string statement, string[] param);

	public static extern void CloseImpl(string handler);

	public static extern List<Dictionary<string,string>> QueryImpl(string handler, string statement, string[] param);


}
