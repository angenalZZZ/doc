"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.License = void 0;
const backend_common_1 = require("@n8n/backend-common");
const config_1 = require("@n8n/config");
const constants_1 = require("@n8n/constants");
const db_1 = require("@n8n/db");
const decorators_1 = require("@n8n/decorators");
const di_1 = require("@n8n/di");
const license_sdk_1 = require("@n8n_io/license-sdk");
const n8n_core_1 = require("n8n-core");
const config_2 = __importDefault(require("./config"));
const license_metrics_service_1 = require("./metrics/license-metrics.service");
const constants_2 = require("./constants");
const LICENSE_RENEWAL_DISABLED_WARNING = 'Automatic license renewal is disabled. The license will not renew automatically, and access to licensed features may be lost!';
let License = class License {
    constructor(logger, instanceSettings, settingsRepository, licenseMetricsService, globalConfig) {
        this.logger = logger;
        this.instanceSettings = instanceSettings;
        this.settingsRepository = settingsRepository;
        this.licenseMetricsService = licenseMetricsService;
        this.globalConfig = globalConfig;
        this.isShuttingDown = false;
        this.logger = this.logger.scoped('license');
    }
    async init({ forceRecreate = false, isCli = false, } = {}) {
        return;
    }
    async loadCertStr() {
        return '';
    }
    async onFeatureChange() {
        void this.broadcastReloadLicenseCommand();
    }
    async onLicenseRenewed() {
        void this.broadcastReloadLicenseCommand();
    }
    async broadcastReloadLicenseCommand() {
        if (config_2.default.getEnv('executions.mode') === 'queue' && this.instanceSettings.isLeader) {
            const { Publisher } = await Promise.resolve().then(() => __importStar(require("./scaling/pubsub/publisher.service")));
            await di_1.Container.get(Publisher).publishCommand({ command: 'reload-license' });
        }
    }
    async saveCertStr(value) {
        return;
    }
    async activate(activationKey) {
        return;
    }
    async reload() {
        return;
    }
    async renew() {
        return;
    }
    async clear() {
        return;
    }
    async shutdown() {
        this.isShuttingDown = true;
        return;
    }
    isLicensed(feature) {
        if (feature == 'feat:showNonProdBanner') {return false} else {return true};
    }
    isSharingEnabled() {
        return true;
    }
    isLogStreamingEnabled() {
        return true;
    }
    isLdapEnabled() {
        return true;
    }
    isSamlEnabled() {
        return true;
    }
    isApiKeyScopesEnabled() {
        return true;
    }
    isAiAssistantEnabled() {
        return true;
    }
    isAskAiEnabled() {
        return true;
    }
    isAiCreditsEnabled() {
        return true;
    }
    isAdvancedExecutionFiltersEnabled() {
        return true;
    }
    isAdvancedPermissionsLicensed() {
        return true;
    }
    isDebugInEditorLicensed() {
        return true;
    }
    isBinaryDataS3Licensed() {
        return true;
    }
    isMultiMainLicensed() {
        return true;
    }
    isVariablesEnabled() {
        return true;
    }
    isSourceControlLicensed() {
        return true;
    }
    isExternalSecretsEnabled() {
        return true;
    }
    isWorkflowHistoryLicensed() {
        return true;
    }
    isAPIDisabled() {
        return false;
    }
    isWorkerViewLicensed() {
        return true;
    }
    isProjectRoleAdminLicensed() {
        return true;
    }
    isProjectRoleEditorLicensed() {
        return true;
    }
    isProjectRoleViewerLicensed() {
        return true;
    }
    isCustomNpmRegistryEnabled() {
        return true;
    }
    isFoldersEnabled() {
        return true;
    }
    getCurrentEntitlements() {
        return [];
    }
    getValue(feature) {
        return undefined;
    }
    getManagementJwt() {
        return 'enterprise-jwt';
    }
    getMainPlan() {
        return undefined;
    }
    getConsumerId() {
        return 'enterprise-consumer';
    }
    getUsersLimit() {
        return constants_1.UNLIMITED_LICENSE_QUOTA;
    }
    getTriggerLimit() {
        return constants_1.UNLIMITED_LICENSE_QUOTA;
    }
    getVariablesLimit() {
        return constants_1.UNLIMITED_LICENSE_QUOTA;
    }
    getAiCredits() {
        return constants_1.UNLIMITED_LICENSE_QUOTA;
    }
    getWorkflowHistoryPruneLimit() {
        return constants_1.UNLIMITED_LICENSE_QUOTA;
    }
    getTeamProjectLimit() {
        return constants_1.UNLIMITED_LICENSE_QUOTA;
    }
    getPlanName() {
        return 'Enterprise';
    }
    getInfo() {
        return 'Enterprise License';
    }
    isWithinUsersLimit() {
        return true;
    }
    enableAutoRenewals() {
        return;
    }
    disableAutoRenewals() {
        return;
    }
    onExpirySoon() {
        return;
    }
};
exports.License = License;
__decorate([
    (0, decorators_1.OnPubSubEvent)('reload-license'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], License.prototype, "reload", null);
__decorate([
    (0, decorators_1.OnShutdown)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], License.prototype, "shutdown", null);
__decorate([
    (0, decorators_1.OnLeaderTakeover)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], License.prototype, "enableAutoRenewals", null);
__decorate([
    (0, decorators_1.OnLeaderStepdown)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], License.prototype, "disableAutoRenewals", null);
exports.License = License = __decorate([
    (0, di_1.Service)(),
    __metadata("design:paramtypes", [backend_common_1.Logger,
        n8n_core_1.InstanceSettings,
        db_1.SettingsRepository,
        license_metrics_service_1.LicenseMetricsService,
        config_1.GlobalConfig])
], License);