"use strict";(self["webpackChunkweb"]=self["webpackChunkweb"]||[]).push([[581],{8581:function(e,t,s){s.r(t),s.d(t,{default:function(){return h}});var r=function(){var e=this;e._self._c;return e._m(0)},a=[function(){var e=this,t=e._self._c;return t("div",{staticClass:"home"},[t("br"),t("br"),t("br"),t("img",{attrs:{alt:"logo",src:s(6949),width:"200"}}),t("div",{staticClass:"hello"},[t("br"),t("br"),t("strong",[e._v("Welcome to Mandrill")]),t("p",[e._v(" If you have any suggestions, bug reports, or annoyances "),t("br"),e._v("please report them to our "),t("a",{attrs:{href:"https://github.com/Clivern/Mandrill/issues",target:"_blank",rel:"noopener"}},[e._v("issue tracker")]),e._v(". ")]),t("br"),t("small",[e._v(" Made with "),t("span",{staticClass:"icon has-text-danger"},[t("i",{staticClass:"fas fa-heart"})]),e._v(" by "),t("a",{attrs:{href:"https://github.com/Clivern",target:"_blank",rel:"noopener"}},[e._v("Clivern")]),t("br")])])])}],l=(s(560),{name:"HomePage",data(){return{loader:{isFullPage:!0,ref:null}}},methods:{loading(){this.loader.ref=this.$buefy.loading.open({container:this.loader.isFullPage?null:this.$refs.element.$el})}},mounted(){this.$emit("refresh-state"),this.loading(),this.$store.dispatch("health/fetchReadiness").then((()=>{this.loader.ref.close()}),(()=>{this.$router.push("/install"),this.loader.ref.close()}))}}),n=l,i=s(1001),o=(0,i.Z)(n,r,a,!1,null,"a7cdec08",null),h=o.exports},6949:function(e,t,s){e.exports=s.p+"img/logo.8dda3450.png"}}]);
//# sourceMappingURL=581.99cd982a.js.map