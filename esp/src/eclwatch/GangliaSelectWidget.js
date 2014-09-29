/*##############################################################################
#    HPCC SYSTEMS software Copyright (C) 2012 HPCC Systems.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
############################################################################## */
define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dojo/i18n",
    "dojo/i18n!./nls/hpcc",
    "dojo/_base/array",
    "dojo/_base/xhr",
    "dojo/on",
    "dojo/store/Memory",

    "dijit/form/FilteringSelect",
    "dijit/registry",

    "hpcc/WsRrd"
], function (declare, lang, i18n, nlsHPCC, arrayUtil, xhr, on, Memory,
    FilteringSelect, registry,
    WsRrd) {
    return declare("GangliaSelectWidget", [FilteringSelect], {
        i18n: nlsHPCC,

        loading: false,
        defaultValue: "",

        //  Implementation  ---
        init: function (params) {
            if (this.initalized)
                return;
            this.initalized = true;
            this.loading = true;
            this.options = [];

            if (params.includeBlank) {
                this.includeBlank = params.includeBlank;
                this.options.push({
                    label: "&nbsp;",
                    value: ""
                });
            }
            if (params.Metrics === true) {
                this.loadGangliaMetrics();
            } else if (params.Clusters === true) {
                this.loadGangliaClusters();
            } else if (params.Servers === true) {
                this.loadGangliaServers();
            }
            if (params.callback) {
                this.callback = params.callback;
            }
        },

        _setValueAttr: function (target) {
            if (target === null)
                target = "";
            this.inherited(arguments);
            if (this.callback) {
                this.callback(this.value, this._getRowAttr());
            }
        },

        _getValueAttr: function () {
            if (this.loading)
                return this.defaultValue;

            return this.value;
        },

        _getRowAttr: function () {
            var context = this;
            var retVal = null;
            arrayUtil.forEach(this.options, function (item, idx) {
                if (context.value === item.value) {
                    retVal = item;
                    return false;
                }
            });
            return retVal;
        },

        loadGangliaClusters: function () {
            var context = this;
            WsRrd.GangliaClusterList({
                request:{
                    Cluster: "",
                    Server: ""
                },
            }).then(function (response) {
                if (lang.exists("GetAvailableClustersResponse", response)) {
                    var targetData = response.GetAvailableClustersResponse.Clusters.Item;
                    for (var i = 0; i < targetData.length; ++i) {
                        context.options.push({
                            label: targetData[i],
                            value: targetData[i]
                        });
                    }

                    if (!context.includeBlank && context._value == "") {
                        if (response.GetAvailableClustersResponse.Clusters.Item["default"]) {
                            context._value = response.GetAvailableClustersResponse.Clusters.Item["default"].Name;
                        } else {
                            context._value = context.options[0].value;
                        }
                    }
                }
                context._postLoad();
            });
        },

        loadGangliaServers: function () {
            var context = this;
            var store = new WsRrd.CreateGangliaServerStore();
            this.control.on('change', function (changedValue) {
                store.set("query", changedValue);
            });
        },

        loadGangliaMetrics: function () {
            var context = this;
            WsRrd.GangliaMetricList({
                request:{
                    Cluster: "",
                    Server: ""
                },
            }).then(function (response) {
                if (lang.exists("GetAvailableMetricsResponse.Metrics", response)) {
                    var targetData = arrayUtil.map(response.GetAvailableMetricsResponse.Metrics.Item, function(item, idx) {
                        return {
                            name: item,
                            id: idx
                        };
                    });

                    var myStore = new Memory({
                        data: targetData
                    });

                    /*if (!context.includeBlank && context._value == "") {
                        if (response.GetAvailableMetricsResponse.Metrics.Item["default"]) {
                            context._value = response.GetAvailableMetricsResponse.Metrics.Item["default"].Name;
                        } else {
                            context._value = context.options[0].value;
                        }
                    }*/
                    context.set("store", myStore);
                }
            });
        }
    });
});
