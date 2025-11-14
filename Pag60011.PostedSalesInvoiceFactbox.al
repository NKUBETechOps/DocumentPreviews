page 60102 "Posted Sales Invoice Factbox"
{
    ApplicationArea = All;
    Caption = 'Posted Sales Invoice Factbox';
    PageType = CardPart;
    SourceTable = "Sales Invoice Doc FctBx Images";

    layout
    {
        area(Content)
        {
            field("Page No.: "; Rec.PageNo)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Invoice Image"; Rec."Image")
            {
                ApplicationArea = All;
                ShowCaption = false;
                ExtendedDatatype = Document;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ReGenerateImages)
            {
                ApplicationArea = All;
                Caption = 'Re-Generate Images';
                Image = Import;
                ToolTip = 'Generate Document Prints into the factbox.';
                trigger OnAction()
                begin
                    UpdatePDFPReviewinFactobox();
                    CurrPage.Update();
                end;
            }

            action(Next)
            {
                ApplicationArea = All;
                Caption = 'Next';
                Image = NextRecord;

                trigger OnAction()
                begin
                    Rec.Next(1);
                end;
            }
            action(Previous)
            {
                ApplicationArea = All;
                Caption = 'Previous';
                Image = PreviousRecord;

                trigger OnAction()
                begin
                    Rec.Next(-1);
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Image = Delete;
                ToolTip = 'Delete the record.';

                trigger OnAction()
                begin
                    DeleteItemPicture;
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        UpdatePDFPReviewinFactobox();
        if Rec.FindFirst() then;
    end;

    procedure UpdatePDFPReviewinFactobox()
    var
        Rec_Ref: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
        TempBlobOrg: Codeunit "Temp Blob";
        PDFFile: Codeunit "PDF Document";
        ImgFormat: Enum "Image Format";
        i: Integer;
        SalesInvFctBxImages: Record "Sales Invoice Doc FctBx Images";
        SalesInvoiceHead: Record "Sales Invoice Header";
    begin
        SalesInvFctBxImages.RESET;
        SalesInvFctBxImages.SetRange("Invoice No.", Rec."Invoice No.");
        if NOT SalesInvFctBxImages.IsEmpty then
            exit;

        Rec_Ref.GetTable(SalesInvoiceHead);
        Rec_Ref.SetView('Where(No.=Const(' + Rec."Invoice No." + '))');
        TempBlob.CreateOutStream(OutStr);
        Report.SaveAs(1306, '', ReportFormat::Pdf, OutStr, Rec_Ref);
        TempBlob.CreateInStream(InStr);
        TempBlobOrg.CreateOutStream(OutStr);
        CopyStream(OutStr, InStr);
        i := 1;
        for i := 1 to PDFFile.GetPdfPageCount(InStr) do begin
            TempBlob.CreateInStream(InStr);
            PDFFile.Load(InStr);
            TempBlob.CreateInStream(InStr);
            PDFFile.ConvertToImage(InStr, ImgFormat::Jpeg, i);
            SalesInvFctBxImages.Init();
            SalesInvFctBxImages."Invoice No." := Rec."Invoice No.";
            SalesInvFctBxImages.Image.ImportStream(InStr, 'Page_' + FORMAT(i), 'image/jpeg');
            SalesInvFctBxImages.PageNo := i;
            SalesInvFctBxImages.Insert();
            TempBlobOrg.CreateInStream(InStr);
            TempBlob.CreateOutStream(OutStr);
            CopyStream(OutStr, InStr);
        end;
    end;

    procedure DeleteItemPicture()
    var
        SalesInvFctBxImages: Record "Sales Invoice Doc FctBx Images";
    begin
        if not Confirm(DeleteImageQst) then
            exit;
        SalesInvFctBxImages.RESET;
        SalesInvFctBxImages.SetRange("Invoice No.", Rec."Invoice No.");
        if NOT SalesInvFctBxImages.IsEmpty then
            SalesInvFctBxImages.DeleteAll()
        else begin
            Message(NothingDel);
        end;
    end;

    var
        DeleteImageQst: Label 'Are you sure you want to delete all Doc. Images?';
        NothingDel: Label 'Nothing to delete';
}
