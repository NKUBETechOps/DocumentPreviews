table 60100 "Sales Invoice Doc FctBx Images"
{
    Caption = 'Sales Invoice Doc FctBx Images';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
        }
        field(2; PageNo; Integer)
        {
            Caption = 'PageNo';
        }
        field(3; Image; Media)
        {
            Caption = 'Image';
        }
    }
    keys
    {
        key(PK; "Invoice No.",PageNo)
        {
            Clustered = true;
        }
    }
}
