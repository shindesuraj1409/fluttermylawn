// ignore_for_file: prefer_single_quotes

import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/services/order/order_request_bodies.dart';

final validShippingAddress = ShippingAddress(
  'test',
  'test',
  '9999999999',
  'Irvine',
  'CA',
  'US',
  '2211 Michelson Dr Ste 1250',
  '',
  '11201',
);

final validBillingAddress = ShippingAddress(
  'test1',
  'test1',
  '8888888888',
  'Irvine',
  'CA',
  'US',
  '2211 Michelson Dr Ste 1250',
  '',
  '11201',
);

final _planJson = {
  "products": [
    {
      "applicationWindow": {
        "zoneId": 1,
        "startingWeekNumber": 6,
        "isWholeYear": false,
        "zoneName": "Zone 1",
        "startDate": "2021-02-12T00:00:00.000Z",
        "endDate": "2021-03-12T00:00:00.000Z",
        "shipStartDate": "2021-01-29T00:00:00.000Z",
        "shipEndDate": "2021-02-26T00:00:00.000Z",
        "season": "Early Spring",
        "seasonSlug": "Early-Spring"
      },
      "parentSku": "prod100050",
      "childProducts": [
        {
          "sku": "22305",
          "quantity": 3,
          "coverage": 5000,
          "price": "17.490000",
          "description":
              "Scotts® Turf Builder® Lawn Food helps you to build a thick, green lawn. It's formulated with exclusive Scotts® All-In-One Particles® technology for even greening and feeding. Using Scotts® Turf Builder® Lawn Food thickens your grass to crowd out new weeds and strengthens your lawn to help protect it against future problems. \n\nApply Scotts® Turf Builder® Lawn Food any time, during any season to unlock your best lawn.",
          "shortDescription":
              "<p> </p>\r\n<ul>\r\n<li>Feeds and strengthens to help protect against future problems\r\n<li>Builds strong, deep roots</li>\r\n<li>Improves lawn's ability to absorb water and nutrients versus an unfed lawn</li>\r\n<li>Formulated with Scotts' exclusive All-in-One Particle technology for even greening and feeding</li>\r\n<li>Apply to any grass type</li>\r\n</ul>",
          "thumbnailImage":
              "https://images.scottsprogram.com/prod/pub/media/catalog/product/2/2/22315.png",
          "thumbnailLabel": "A bag of Scotts® Turf Builder® Lawn Food (5m)"
        }
      ],
      "name": "Scotts® Turf Builder® Lawn Food",
      "isAddOn": false
    },
    {
      "applicationWindow": {
        "isWholeYear": false,
        "zoneName": "Zone 1",
        "zoneId": 1,
        "startingWeekNumber": 18,
        "startDate": "2021-05-07T00:00:00.000Z",
        "endDate": "2021-06-04T00:00:00.000Z",
        "shipStartDate": "2021-04-23T00:00:00.000Z",
        "shipEndDate": "2021-05-21T00:00:00.000Z",
        "season": "Early Summer",
        "seasonSlug": "Early-Summer"
      },
      "parentSku": "25295",
      "childProducts": [
        {
          "sku": "30178",
          "quantity": 3,
          "coverage": 4000,
          "price": "49.990000",
          "description":
              "Get up to a 50% thicker lawn* with Scotts® Turf Builder® Thick'R Lawn® Bermudagrass. The 3-in-1 solution contains seeds to fill gaps in the current lawn; fertilizer for a thicker, greener turf; and a soil improver for enhanced root development. Apply to a Bermudagrass lawn in late spring or early summer using a Scotts broadcast, rotary, drop, Elite, hand-held, or Wizz spreader. Water in and keep the soil moist until the seeds germinate. Scotts® Turf Builder® Thick'R Lawn® Bermudagrass is uniquely formulated to help turn weak, thin Bermudagrass into a thicker, greener lawn with stronger roots in one easy application. *Subject to proper care; results may vary based on current condition of lawn.",
          "shortDescription": "",
          "thumbnailImage":
              "https://images.scottsprogram.com/prod/pub/media/catalog/product/3/0/30178.png",
          "thumbnailLabel": ""
        }
      ],
      "name": "Scotts® Turf Builder® Thick'R Lawn™ Bermudagrass",
      "isAddOn": false
    },
    {
      "applicationWindow": {
        "zoneName": "Zone 1",
        "zoneId": 1,
        "isWholeYear": false,
        "startingWeekNumber": 18,
        "startDate": "2021-05-07T00:00:00.000Z",
        "endDate": "2021-06-04T00:00:00.000Z",
        "shipStartDate": "2021-04-23T00:00:00.000Z",
        "shipEndDate": "2021-05-21T00:00:00.000Z",
        "season": "Early Summer",
        "seasonSlug": "Early-Summer"
      },
      "parentSku": "s14966",
      "childProducts": [
        {
          "sku": "49022",
          "quantity": 1,
          "coverage": 12000,
          "price": "69.990000",
          "description":
              "Scotts® Turf Builder® Summer Lawn Food greens grass with up to 50% less water.* It is powered by EveryDrop® technology which helps drive water into hard dry soil.  Plus, it feeds to build strong, deep roots. *When Used as directed, greening effects last up to 6 weeks, results will vary due to temperature and turfgrass type.",
          "shortDescription":
              "<p> </p>\r\n<ul>\r\n<li>Green Grass with up to 50% Less Water (When used as directed, greening effects last up to 6 weeks, results will vary due to temperature and turfgrass type)\r\n<li>2 in 1 Lawn Food and Water Maximizer</li>\r\n<li>Powered by Everydrop Technology</li>\r\n<li>Safe on all Grass Types</li>\r\n<li>Builds strong, deep roots</li>\r\n</ul>",
          "thumbnailImage":
              "https://images.scottsprogram.com/prod/pub/media/catalog/product/4/9/49022.png",
          "thumbnailLabel":
              "A bag of Scotts® Turf Builder® Summer Lawn Food (12m)"
        }
      ],
      "name": "Scotts® Turf Builder® Summer Lawn Food",
      "isAddOn": false
    },
    {
      "applicationWindow": {
        "zoneName": "Zone 1",
        "zoneId": 1,
        "isWholeYear": false,
        "startingWeekNumber": 40,
        "startDate": "2020-10-02T00:00:00.000Z",
        "endDate": "2020-10-30T00:00:00.000Z",
        "shipStartDate": "2020-10-15T13:35:41.034Z",
        "shipEndDate": "2020-10-16T00:00:00.000Z",
        "season": "Early Fall",
        "seasonSlug": "Early-Fall"
      },
      "parentSku": "prod11670004",
      "childProducts": [
        {
          "sku": "25006A",
          "quantity": 3,
          "coverage": 5000,
          "price": "23.990000",
          "description":
              "Scotts® Turf Builder® Weed & Feed3 with WeedGrip Technology, grips the weeds you see and the ones you don't for up to 2X more powerful dandelion and clover control (versus previous formulation), all while feeding and thickening your lawn to crowd out weeds.",
          "shortDescription":
              "<p> </p>\r\n<ul>\r\n<li>Up to 2X more powerful dandelion and clover control (vs. previous formula)</li>\r\n<li>Clears out dandelions and clover—satisfaction guaranteed</li>\r\n<li>Weedgrip<sup>®</sup> Technology grips the weeds you see—and the ones you don't</li>\r\n<li>Scotts® most powerful weed and feed Feeds to thicken lawns and crowd out weeds</li>\r\n</ul>",
          "thumbnailImage":
              "https://images.scottsprogram.com/prod/pub/media/catalog/product/2/5/25006.png",
          "thumbnailLabel": "A bag of Scotts® Turf Builder® Weed & Feed 5 M"
        }
      ],
      "name": "Scotts® Turf Builder® Weed & Feed",
      "isAddOn": false
    }
  ],
};

final _planJsonWithAddOns = {
  "addOnProducts": [
    {
      "isAddOn": true,
      "applicationWindow": {
        "zoneId": 5,
        "endDate": "2020-12-31T00:00:00.000Z",
        "startDate": "2020-01-01T00:00:00.000Z",
        "zoneName": "Zone 5",
        "shipEndDate": "2020-12-17T00:00:00.000Z",
        "startingWeekNumber": 1,
        "seasonSlug": "add-ons",
        "season": "Add Ons",
        "shipStartDate": "2020-10-28T13:14:35.631Z",
        "isWholeYear": true
      },
      "childProducts": [
        {
          "thumbnailLabel": "",
          "quantity": 1,
          "price": "36.990000",
          "thumbnailImage":
              "https://images.scottsprogram.com/prod/pub/media/catalog/product/s/p/spreader.10.png",
          "description":
              "Broadcast spreader with exclusive EdgeGuard® technology. Holds up to 5,000 Sq. Ft. of Scotts® lawn products.  ",
          "sku": "76121",
          "coverage": 1000000,
          "shortDescription":
              "Broadcast spreader with exclusive EdgeGuard® technology. Holds up to 5,000 Sq. Ft. of Scotts® lawn products.  "
        }
      ],
      "name": "Scotts® Turf Builder® with Edgeguard Mini Spreader",
      "parentSku": "8541"
    }
  ],
  "products": [
    {
      "childProducts": [
        {
          "thumbnailImage":
              "https://images.scottsprogram.com/prod/pub/media/catalog/product/2/2/22315_1.png",
          "thumbnailLabel": "A bag of Scotts® Turf Builder® Lawn Food (15m)",
          "sku": "22315",
          "quantity": 2,
          "coverage": 15000,
          "shortDescription":
              "<p> </p>\r\n<ul>\r\n<li>Feeds and strengthens to help protect against future problems\r\n<li>Builds strong, deep roots</li>\r\n<li>Improves lawn's ability to absorb water and nutrients versus an unfed lawn</li>\r\n<li>Formulated with Scotts' exclusive All-in-One Particle technology for even greening and feeding</li>\r\n<li>Apply to any grass type</li>\r\n</ul>",
          "description":
              "Scotts® Turf Builder® Lawn Food helps you to build a thick, green lawn. It's formulated with exclusive Scotts® All-In-One Particles® technology for even greening and feeding. Using Scotts® Turf Builder® Lawn Food thickens your grass to crowd out new weeds and strengthens your lawn to help protect it against future problems. \n\nApply Scotts® Turf Builder® Lawn Food any time, during any season to unlock your best lawn.",
          "price": "43.990000"
        },
        {
          "thumbnailImage":
              "https://images.scottsprogram.com/prod/pub/media/catalog/product/2/2/22315.png",
          "sku": "22305",
          "description":
              "Scotts® Turf Builder® Lawn Food helps you to build a thick, green lawn. It's formulated with exclusive Scotts® All-In-One Particles® technology for even greening and feeding. Using Scotts® Turf Builder® Lawn Food thickens your grass to crowd out new weeds and strengthens your lawn to help protect it against future problems. \n\nApply Scotts® Turf Builder® Lawn Food any time, during any season to unlock your best lawn.",
          "thumbnailLabel": "A bag of Scotts® Turf Builder® Lawn Food (5m)",
          "price": "17.490000",
          "quantity": 2,
          "shortDescription":
              "<p> </p>\r\n<ul>\r\n<li>Feeds and strengthens to help protect against future problems\r\n<li>Builds strong, deep roots</li>\r\n<li>Improves lawn's ability to absorb water and nutrients versus an unfed lawn</li>\r\n<li>Formulated with Scotts' exclusive All-in-One Particle technology for even greening and feeding</li>\r\n<li>Apply to any grass type</li>\r\n</ul>",
          "coverage": 5000
        }
      ],
      "isAddOn": false,
      "name": "Scotts® Turf Builder® Lawn Food",
      "parentSku": "prod100050",
      "applicationWindow": {
        "season": "early spring",
        "isWholeYear": false,
        "endDate": "2021-04-23T00:00:00.000Z",
        "shipEndDate": "2021-04-09T00:00:00.000Z",
        "shipStartDate": "2021-03-12T00:00:00.000Z",
        "seasonSlug": "early-spring",
        "startDate": "2021-03-26T00:00:00.000Z",
        "zoneName": "Zone 5",
        "zoneId": 5,
        "startingWeekNumber": 12
      }
    },
    {
      "name": "Scotts® Turf Builder® Weed & Feed",
      "isAddOn": false,
      "applicationWindow": {
        "startingWeekNumber": 18,
        "season": "late spring",
        "startDate": "2021-05-07T00:00:00.000Z",
        "isWholeYear": false,
        "endDate": "2021-06-04T00:00:00.000Z",
        "zoneName": "Zone 5",
        "seasonSlug": "late-spring",
        "zoneId": 5,
        "shipStartDate": "2021-04-23T00:00:00.000Z",
        "shipEndDate": "2021-05-21T00:00:00.000Z"
      },
      "childProducts": [
        {
          "description":
              "Scotts® Turf Builder® Weed & Feed3 with WeedGrip Technology, grips the weeds you see and the ones you don't for up to 2X more powerful dandelion and clover control*, all while feeding and thickening your lawn to crowd out weeds.   *versus previous formulation",
          "coverage": 15000,
          "price": "61.490000",
          "thumbnailLabel": "A bag of Scotts® Turf Builder® Weed & Feed₃ (15m)",
          "sku": "25009",
          "quantity": 2,
          "thumbnailImage":
              "https://images.scottsprogram.com/prod/pub/media/catalog/product/2/5/25009.png",
          "shortDescription":
              "<p> </p>\r\n<ul>\r\n<li>Up to 2X more powerful vs. previous formulation\r\n<li>Clears out Dandelions &amp; Clover - Guaranteed* *See Scotts No-Quibble Guarantee on back panel</li>\r\n<li>Scotts® most powerful weed and feed</li>\r\n<li>Feeds to thicken lawn and crowd out weeds</li>\r\n<li>Weedgrip® Technology grips the weeds you see—and the ones you don't</li>\r\n<li>Apply when weeds are actively growing and daytime temperatures are 60°F to 90°F. In the northern US, weeds are most active Apr-Sept. In the southern US, weeds are most active Mar-Sept.</li>\r\n</ul>"
        },
        {
          "sku": "25006A",
          "coverage": 5000,
          "thumbnailImage":
              "https://images.scottsprogram.com/prod/pub/media/catalog/product/2/5/25006.png",
          "price": "23.990000",
          "description":
              "Scotts® Turf Builder® Weed & Feed3 with WeedGrip Technology, grips the weeds you see and the ones you don't for up to 2X more powerful dandelion and clover control (versus previous formulation), all while feeding and thickening your lawn to crowd out weeds.",
          "thumbnailLabel": "A bag of Scotts® Turf Builder® Weed & Feed 5 M",
          "quantity": 2,
          "shortDescription":
              "<p> </p>\r\n<ul>\r\n<li>Up to 2X more powerful dandelion and clover control (vs. previous formula)</li>\r\n<li>Clears out dandelions and clover—satisfaction guaranteed</li>\r\n<li>Weedgrip<sup>®</sup> Technology grips the weeds you see—and the ones you don't</li>\r\n<li>Scotts® most powerful weed and feed Feeds to thicken lawns and crowd out weeds</li>\r\n</ul>"
        }
      ],
      "parentSku": "prod11670004"
    },
    {
      "applicationWindow": {
        "seasonSlug": "early-summer",
        "shipEndDate": "2021-07-02T00:00:00.000Z",
        "season": "early summer",
        "isWholeYear": false,
        "zoneId": 5,
        "zoneName": "Zone 5",
        "startingWeekNumber": 24,
        "startDate": "2021-06-18T00:00:00.000Z",
        "shipStartDate": "2021-06-04T00:00:00.000Z",
        "endDate": "2021-07-16T00:00:00.000Z"
      },
      "childProducts": [
        {
          "thumbnailLabel":
              "A bag of Scotts® Turf Builder® Summerguard® Lawn Food with Insect Control (15m)",
          "description":
              "Apply Scotts® Turf Builder® SummerGuard® Lawn Food with Insect Control to kill and protect against listed bugs and to feed and strengthen your lawn against heat and drought.",
          "thumbnailImage":
              "https://images.scottsprogram.com/prod/pub/media/catalog/product/4/9/49020.png",
          "shortDescription":
              "<p> </p>\r\n<ul>\r\n<li>Feeds and strengthens your lawn against heat and drought\r\n<li>Kills and protects against listed bugs</li>\r\n<li>Won't burn lawn - guaranteed</li>\r\n<li>Apply in Summer: June - August</li>\r\n</ul>",
          "quantity": 2,
          "coverage": 15000,
          "sku": "49020",
          "price": "71.990000"
        },
        {
          "coverage": 5000,
          "quantity": 2,
          "thumbnailLabel":
              "A bag of Scotts® Turf Builder® Summerguard® Lawn Food with Insect Control (5m)",
          "thumbnailImage":
              "https://images.scottsprogram.com/prod/pub/media/catalog/product/4/9/49013.png",
          "description":
              "Apply Scotts® Turf Builder® SummerGuard® Lawn Food with Insect Control to kill and protect against listed bugs and to feed and strengthen your lawn against heat and drought.",
          "shortDescription":
              "<p> </p>\r\n<ul>\r\n<li>Feeds and strengthens your lawn against heat and drought\r\n<li>Kills and protects against listed bugs</li>\r\n<li>Won't burn lawn - guaranteed</li>\r\n<li>Apply in Summer: June - August</li>\r\n</ul>",
          "sku": "49013",
          "price": "25.990000"
        }
      ],
      "parentSku": "prod100066",
      "name": "Scotts® Turf Builder® With SummerGuard®",
      "isAddOn": false
    },
    {
      "name": "Scotts® Turf Builder® Thick'R Lawn™ Sun & Shade",
      "applicationWindow": {
        "seasonSlug": "early-fall",
        "shipEndDate": "2021-10-01T00:00:00.000Z",
        "shipStartDate": "2021-09-03T00:00:00.000Z",
        "season": "early fall",
        "zoneId": 5,
        "endDate": "2021-10-15T00:00:00.000Z",
        "isWholeYear": false,
        "startDate": "2021-09-17T00:00:00.000Z",
        "zoneName": "Zone 5",
        "startingWeekNumber": 37
      },
      "childProducts": [
        {
          "sku": "30158C",
          "quantity": 10,
          "thumbnailImage":
              "https://images.scottsprogram.com/prod/pub/media/catalog/product/3/0/30158c.png",
          "thumbnailLabel":
              "A bag of Scotts® Turf Builder® THICK'R Lawn™ Sun & Shade (4m)",
          "shortDescription":
              "<p> </p>\r\n<ul>\r\n<li>3-in-1 solution for thin lawns\r\n<li>Get up to a 50% thicker lawn with just one application (Subject to proper care. Results may vary based on current condition of lawn.)</li>\r\n<li>Helps turn weak, thin grass into a thick green lawn</li>\r\n<li>Includes seed, fertilizer, and soil improver for thicker, greener turf</li>\r\n<li>One easy application with a spreader</li>\r\n</ul>",
          "coverage": 4000,
          "description":
              "Scotts® Turf Builder® THICK'R Lawn™ Sun and Shade has everything you need to help turn weak, thin grass into a thick, green lawn. With this 3-in-1 solution get up to a 50% thicker lawn with just one application (subject to proper care)! THICK'R Lawn contains soil improver for enhanced root development, seed to fill gaps with new grass, and fertilizer to feed new grass and thicken and green existing turf. This product is intended for use on an entire lawn and can be applied easily with a Scotts® spreader. Results may vary based on current condition of lawn.",
          "price": "51.490000"
        }
      ],
      "isAddOn": false,
      "parentSku": "s14921"
    },
    {
      "parentSku": "prod100052",
      "applicationWindow": {
        "shipEndDate": "2021-10-01T00:00:00.000Z",
        "zoneId": 5,
        "shipStartDate": "2021-09-03T00:00:00.000Z",
        "endDate": "2021-10-15T00:00:00.000Z",
        "isWholeYear": false,
        "seasonSlug": "late-fall",
        "zoneName": "Zone 5",
        "startingWeekNumber": 37,
        "season": "late fall",
        "startDate": "2021-09-17T00:00:00.000Z"
      },
      "childProducts": [
        {
          "quantity": 2,
          "sku": "38615",
          "coverage": 15000,
          "thumbnailLabel":
              "A bag of Scotts® Turf Builder® WinterGuard® Fall Lawn Food (15m)",
          "thumbnailImage":
              "https://images.scottsprogram.com/prod/pub/media/catalog/product/3/8/38615.jpg",
          "description":
              "Fall is the best time to feed with Scotts® Turf Builder® WinterGuard® Fall Lawn Food. It builds strong, deep roots for a better lawn next spring. The lawn food is formulated to deliver the nutrients lawns need in the fall to repair damage from the heat, drought and activity of the summer, ensuring stronger grass in the spring.",
          "shortDescription":
              "<p> </p>\r\n<ul>\r\n<li>Builds strong, deep roots for a better lawn next spring\r\n<li>Fall is the best time to feed</li>\r\n<li>Delivers nutrients that help repair damage from heat, drought and activity</li>\r\n<li>Improves lawn's ability to absorb water and nutrients versus an unfed lawn</li>\r\n<li>Apply to any grass type</li>\r\n</ul>",
          "price": "49.990000"
        },
        {
          "thumbnailLabel":
              "A bag of Scotts® Turf Builder® WinterGuard® Fall Lawn Food (5m)",
          "sku": "38605D",
          "coverage": 5000,
          "price": "21.490000",
          "quantity": 2,
          "description":
              "Fall is the best time to feed with Scotts® Turf Builder® WinterGuard® Fall Lawn Food. It builds strong, deep roots for a better lawn next spring. The lawn food is formulated to deliver the nutrients lawns need in the fall to repair damage from the heat, drought and activity of the summer, ensuring stronger grass in the spring.",
          "thumbnailImage":
              "https://images.scottsprogram.com/prod/pub/media/catalog/product/3/8/38605a.jpg",
          "shortDescription":
              "<p> </p>\r\n<ul>\r\n<li>Builds strong, deep roots for a better lawn next spring\r\n<li>Fall is the best time to feed</li>\r\n<li>Delivers nutrients that help repair damage from heat, drought and activity</li>\r\n<li>Improves lawn's ability to absorb water and nutrients versus an unfed lawn</li>\r\n<li>Apply to any grass type</li>\r\n</ul>"
        }
      ],
      "isAddOn": false,
      "name": "Scotts® Turf Builder® WinterGuard"
    }
  ]
};

final planData = Plan.fromJson(_planJson);

final planDataWithAddOns = Plan.fromJson(_planJsonWithAddOns);
