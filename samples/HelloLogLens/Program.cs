using HelloLogLens;

Console.WriteLine("Hello, LogLens!");

var path = args.Length > 0 ? args[0] : Path.Combine(AppContext.BaseDirectory, "sample-log.txt");
if (!File.Exists(path))
{
    Console.Error.WriteLine($"Log file not found: {path}");
    return 1;
}

var counts = LogSummarizer.CountByLevel(File.ReadLines(path));

Console.WriteLine($"Summary of {Path.GetFileName(path)}:");
foreach (var (level, count) in counts)
{
    Console.WriteLine($"  {level,-5} {count}");
}

return 0;
