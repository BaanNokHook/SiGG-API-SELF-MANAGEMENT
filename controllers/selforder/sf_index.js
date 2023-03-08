/**
 * SiGG-API-SELF-MANAGEMENT
 * selforder index.
 * router for manage program.
 */


var SF_Tran = require('./sf_transaction');  
var SF_Master = require('./sf_master.js');
var SF_Set = require('./sf_setting.js');   
var SF_Rpt = require('./sf_report.js');  
var SF_Opt = require('./sf_optimizedata.js');  
var test = require('./test');  

var pMyOutletId = ':CompanyId/:BrandId/:OutletId';  
var pMyTableId = ':CompanyId/:BrandId/:OutletId/:SystemDate/:TableNo/:StartTime';
var pMyTableIdByUUID = ':CompanyId/:BrandId/:OutletId/:SystemDate/:TableNo/:StartTime/:isDevice';  /** Params Using by UUID */

async function routes(fasity, option) {

    // ----------- Master files.
    fastify.get('/getOutletSetting/' + pMyOutletId, SF_Master.getOutletSetting);   
    fastify.get('/getOutletTable/' + pMyOutletId, SF_Master.getOutletTable);  
    fastify.get('/getCategory/' + pMyOutletId, SF_Master.getCategory);  
    fastify.get('/getProduct/' + pMyOutletId, SF_Master.getProduct);   
    fastify.get('/getProductRecommend/' + pMyOutletId, SF_Master.getProductRecommend);  
    fastify.get('/getproductsize/' + pMyOutletId, SF_Master.getProductSize);  
    fastify.get('/getProductPackage/' + pMyOutletId, SF_Master.getProductPackage);  
    fastify.get('/getProductSubmenu/' + pMyOutletId, SF_Master.getProductSubmenu);   
    fastify.get('/getmodifylistall/' + pMyOutletId, SF_Master.getModifyListAll);   
    fastify.get('/resetMasterTable/' + pMyOutletId, SF_Master.resetMasterTable);
    fastify.get('/getProductTest/' + pMyOutletId, SF_Master.getProductTest);
    fastify.get('/getRounding/' + pMyOutletId, SF_Master.getRounding);  

    //  ----------- Transecton Ordering.
    fastify.post('/inputPax', SF_Tran.inputPax);
    fastify.post('/orderingItemDelete', SF_Tran.orderingItemDelete);
    fastify.post('/saveOrdering', SF_Tran.saveOrdering);
    fastify.post('/moveOrderingToOrdered', SF_Tran.moveOrderingToOrdered);
    fastify.post('/moveOrderingToOrderedByUUID', SF_Tran.moveOrderingToOrderedByUUID); /** get Ordering Al by Using UUID */
    fastify.post('/callRemoveMultiItems', SF_Tran.RemoveMultiItem);
    fastify.post('/CallBilling', SF_Tran.CallBilling);
    fastify.post('/callWaiter', SF_Tran.callWaiter);
    // Transections.
    fastify.get('/getorderingall/' + pMyTableId, SF_Tran.getOrderingAll);
    fastify.get('/getorderingallByUUID/' + pMyTableIdByUUID, SF_Tran.getOrderingAllByUUID); /** get Ordering Al by Using UUID */
    fastify.get('/getorderdetailall/' + pMyTableId, SF_Tran.getOrderDetailAll);


    //  ----------- Setting.
    fastify.get('/getRunningText/' + pMyOutletId, SF_Set.getRunningText);
    fastify.get('/getBanner/' + pMyOutletId, SF_Set.getBanner);
    fastify.get('/getWelcomeText/' + pMyOutletId, SF_Set.getWelcomeText);
    var pMyOutletModule = ':CompanyId/:BrandId/:OutletId/:Module';
    fastify.get('/getLanguageCaption/' + pMyOutletModule, SF_Set.getLanguageCaption);
    fastify.get('/AdjustProductImageFile/' + pMyOutletId, SF_Set.AdjustProductImageFile);


    // ------------- Report
    var pMyReportRang = ':CompanyId/:BrandId/:OutletId/:StartDate/:EndDate';
    fastify.get('/OrderHistory/'+pMyReportRang, SF_Rpt.OrderHistory);
    fastify.get('/OrderRankingQty/'+pMyReportRang, SF_Rpt.OrderRankingQty);
    fastify.get('/OrderRankingAmt/'+pMyReportRang, SF_Rpt.OrderRankingAmt);


    // Optimize database
    fastify.get('/OptimizeDatabase/', SF_Opt.OptimizeDatabase);

    // Test program
    fastify.get('/david/:Code', test.david);
    fastify.get('/david1', test.david1);
    fastify.post('/testPost', test.testPost);
    fastify.post('/testChkPost', test.testChkPost);


    // fastify.get('/:id', async (req, res) => {
    //     res.send({
    //         id: req.params.id,
    //         firstName: "david",
    //         lastName: "clexpert"

    //     });
    // });

};

module.exports = routes;