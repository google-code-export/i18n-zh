using System;
using System.Xml;
using System.Xml.Schema;
using System.IO;
class DTDValidator
{
    private static bool isValid = true;

    static void Main(string[] args)
    {
        XmlReader r;

        XmlReaderSettings s = new XmlReaderSettings();
        s.ValidationType = ValidationType.DTD;
        s.ProhibitDtd = false;
        s.ValidationEventHandler += new ValidationEventHandler(MyValidationEventHandler);


        if (args.Length >= 1)
        {
            try
            {
                r = XmlReader.Create(args[0], s);
            }
            catch (FileNotFoundException e)
            {
                Console.Error.WriteLine(e.Message);
                return;
            }
        }
        else
        {
            r = XmlReader.Create(Console.In, s);
        }

        try
        {
            while (r.Read()) ;
        }catch(XmlException e) {
            Console.Error.WriteLine("XmlException: " + e.Message);
            return;
        }

        r.Close();

        if (isValid)
        {
            Console.WriteLine("Document is valid");
        }
        else
        {
            Console.Error.WriteLine("Document is invalid");
        }

    }

    public static void MyValidationEventHandler(Object sender, ValidationEventArgs args)
    {
        isValid = false;
        IXmlLineInfo v = (IXmlLineInfo)sender;

        if (v.HasLineInfo())
        {
            Console.Error.WriteLine("Warning: Line " + v.LineNumber + ", Position " + v.LinePosition + "; " + args.Message + "\n");
        }
        else
        {
            Console.Error.WriteLine("Warning: " + args.Message + "\n");
        }
    }
}
