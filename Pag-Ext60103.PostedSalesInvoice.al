pageextension 60103 PostedSalesInvoiceCard extends "Posted Sales Invoice"
{
    layout
    {
        addfirst(factboxes)
        {
            part(PostedSalesInvoiceFactbox; "Posted Sales Invoice Factbox")
            {
                SubPageLink = "Invoice No." = field("No.");
                ApplicationArea = All;
            }
        }
    }
}
