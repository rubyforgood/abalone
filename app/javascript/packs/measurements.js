document.addEventListener("DOMContentLoaded",function(){
    let typeSelect = document.querySelector('#data_import_type')
    updateDataImportDownload(typeSelect.value)

    typeSelect.addEventListener('change', (e) => {
        updateDataImportDownload(e.target.value)
    })
});

const updateDataImportDownload = (val) => {
    document.querySelector('#data-import-template-download')
        .href=`/samples/${val}.csv`
}
